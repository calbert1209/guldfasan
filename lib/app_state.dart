import 'dart:async';
import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/services/fetcher.dart';

// NOTE Piping ReceivePort through StreamController prevents nasty error on re-render
// SEE: https://stackoverflow.com/a/64978367
class AppState with ChangeNotifier {
  AppState(this.dbService, this.receivePort, {Connectivity? connectivity})
      : this.connectivity = connectivity ?? Connectivity() {
    this.receivePort.listen((message) {
      if (message is FetchedMessage && message.hasSendPort()) {
        fromWorker = message.sendPort!;
        updateIsolateDuration(fromWorker!);
      }
      _controller.add(message);
    });
    try {
      _connectivitySubscription =
          this.connectivity.onConnectivityChanged.listen((results) {
        if (fromWorker != null) {
          updateIsolateDuration(fromWorker!, results: results);
        }
      });
    } catch (_) {
      // Platform channels unavailable in headless test environments
    }
    loadPortfolio();
  }

  final DatabaseService dbService;
  final ReceivePort receivePort;
  final Connectivity connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  SendPort? fromWorker;
  final StreamController<FetchedMessage> _controller =
      StreamController.broadcast();

  Iterable<PositionCollection>? _portfolio;
  Future<Iterable<PositionCollection>>? _portfolioFuture;
  Object? _portfolioError;
  bool _isLoadingPortfolio = false;

  Iterable<PositionCollection>? get portfolioCached => _portfolio;
  bool get isLoadingPortfolio => _isLoadingPortfolio;
  Object? get portfolioError => _portfolioError;

  Future<Iterable<PositionCollection>> get portfolio {
    if (_portfolio != null && !_isLoadingPortfolio) {
      return Future.value(_portfolio!);
    }
    return _portfolioFuture ?? loadPortfolio();
  }

  Future<Iterable<PositionCollection>> loadPortfolio() {
    _isLoadingPortfolio = true;
    _portfolioFuture = _fetchPortfolio();
    return _portfolioFuture!;
  }

  Future<Iterable<PositionCollection>> _fetchPortfolio() async {
    try {
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
      _portfolio = collections;
      _portfolioError = null;
      _isLoadingPortfolio = false;
      notifyListeners();
      return collections;
    } catch (e) {
      _portfolioError = e;
      _isLoadingPortfolio = false;
      notifyListeners();
      return _portfolio ?? [];
    }
  }

  Future<int> addPosition(Position position) async {
    var nextIndex = await dbService.insert(position);
    await loadPortfolio();
    return nextIndex;
  }

  Future<int> deletePosition(int id) async {
    var result = await dbService.delete(id);
    await loadPortfolio();
    return result;
  }

  Future<int> updatePosition(Position position) async {
    var result = await dbService.update(position);
    await loadPortfolio();
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

  Future<void> updateIsolateDuration(SendPort sendPort,
      {List<ConnectivityResult>? results}) async {
    try {
      final connectivityResults =
          results ?? await connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.wifi)) {
        sendPort.send(const Duration(seconds: 30));
      } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
        sendPort.send(const Duration(seconds: 60));
      } else {
        sendPort.send(const Duration(seconds: 120));
      }
    } catch (_) {
      // In headless test environments or when connectivity platform channel is unavailable, do nothing
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _controller.close();
    super.dispose();
  }
}
