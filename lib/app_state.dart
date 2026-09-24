import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/services/fetcher.dart';

// NOTE Piping ReceivePort through StreamController prevents nasty error on re-render
// SEE: https://stackoverflow.com/a/64978367
class AppState with ChangeNotifier {
  AppState(this.dbService, this.receivePort) {
    this.receivePort.listen((message) {
      if (message is FetchedMessage && message.hasSendPort()) {
        fromWorker = message.sendPort!;
      }
      _controller.add(message);
    });
  }

  final DatabaseService dbService;
  final ReceivePort receivePort;
  SendPort? fromWorker;
  final StreamController<FetchedMessage> _controller =
      StreamController.broadcast();

  Future<Iterable<PositionCollection>> get portfolio async {
    var positionMaps = await dbService.queryAll();
    print("got data from db. entry count: ${positionMaps.length}");
    var map = positionMaps
        .map((entry) => Position.fromMap(entry))
        .fold<Map<String, PositionCollection>>(
      Map<String, PositionCollection>(),
      (map, entry) {
        if (!map.containsKey(entry.symbol)) {
          map[entry.symbol] = PositionCollection(
            symbol: entry.symbol,
            positions: [],
          );
        }

        map[entry.symbol]!.positions.add(entry);
        return map;
      },
    );
    final collections = map.values.toList()
      ..sort((a, b) {
        final cmp = a.symbol.toLowerCase().compareTo(b.symbol.toLowerCase());
        return cmp != 0 ? cmp : a.symbol.compareTo(b.symbol);
      });
    for (var collection in collections) {
      collection.positions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
    return collections;
  }

  Future<int> addPosition(Position position) async {
    var nextIndex = await dbService.insert(position);
    notifyListeners();
    return nextIndex;
  }

  Future<int> deletePosition(int id) async {
    var result = await dbService.delete(id);
    notifyListeners();
    return result;
  }

  Future<int> updatePosition(Position position) async {
    var result = await dbService.update(position);
    notifyListeners();
    return result;
  }

  Stream<FetchedMessage> get stream => _controller.stream;

  void triggerImmediateFetch() {
    if (fromWorker is SendPort) {
      fromWorker?.send("immediate");
    }
  }

  Future<void> refreshPrices({Duration timeout = const Duration(seconds: 10)}) async {
    final nextMessage = stream.first.timeout(timeout);
    triggerImmediateFetch();
    try {
      await nextMessage;
    } catch (_) {
      // Timeout or stream error: gracefully complete so spinner dismisses
    }
    notifyListeners();
  }
}
