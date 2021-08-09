import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';

// NOTE Piping ReceivePort through StreamController prevents nasty error on re-render
// SEE: https://stackoverflow.com/a/64978367
class AppState with ChangeNotifier {
  AppState(this.dbService, this.receivePort) {
    this.receivePort.listen((message) => _controller.add(message));
  }

  final DatabaseService dbService;
  final ReceivePort receivePort;
  final StreamController<dynamic> _controller = StreamController.broadcast();

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
    return map.values;
  }

  Future<int> addPosition(Position position) async {
    var nextIndex = await dbService.insert(position);
    // var nextPosition = Position(
    //   id: nextIndex,
    //   symbol: position.symbol,
    //   units: position.units,
    //   price: position.price,
    //   dateTime: position.dateTime,
    // );
    notifyListeners();
    return nextIndex;
  }

  Stream<dynamic> get stream => _controller.stream;
}
