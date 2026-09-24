import 'dart:async';
import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/services/fetcher.dart';

class CountingFakeDatabaseService extends DatabaseService {
  int queryAllCount = 0;
  final List<Map<String, dynamic>> data = [];

  CountingFakeDatabaseService([List<Map<String, dynamic>>? initialData]) {
    if (initialData != null) {
      data.addAll(initialData);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> queryAll() async {
    queryAllCount++;
    return List.from(data);
  }

  @override
  Future<int> insert(Position position) async {
    final map = position.toMap();
    map[PositionKey.id] = data.length + 1;
    data.add(map);
    return data.length;
  }

  @override
  Future<int> delete(int id) async {
    data.removeWhere((item) => item[PositionKey.id] == id);
    return 1;
  }

  @override
  Future<int> update(Position position) async {
    final idx = data.indexWhere((item) => item[PositionKey.id] == position.id);
    if (idx != -1) {
      data[idx] = position.toMap();
      return 1;
    }
    return 0;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppState portfolio caching (Phase 2)', () {
    late ReceivePort receivePort;
    late CountingFakeDatabaseService dbService;

    setUp(() {
      receivePort = ReceivePort();
      final initialPosition = Position(
        id: 1,
        symbol: 'BTC',
        units: 0.5,
        price: 4000000.0,
        dateTime: DateTime(2022, 1, 1),
      );
      dbService = CountingFakeDatabaseService([initialPosition.toMap()]);
    });

    tearDown(() {
      receivePort.close();
    });

    test('caches portfolio and prevents redundant queryAll() calls on repeated access',
        () async {
      final appState = AppState(dbService, receivePort);

      // Await initial load
      final firstFetch = await appState.portfolio;
      expect(firstFetch.length, equals(1));
      expect(firstFetch.first.symbol, equals('BTC'));
      expect(dbService.queryAllCount, equals(1));
      expect(appState.portfolioCached, isNotNull);
      expect(appState.portfolioCached!.first.symbol, equals('BTC'));

      // Subsequent access should return cached data without extra queryAll call
      final secondFetch = await appState.portfolio;
      expect(secondFetch.length, equals(1));
      expect(dbService.queryAllCount, equals(1)); // Still 1! No extra DB hit

      final thirdFetch = await appState.portfolio;
      expect(thirdFetch.length, equals(1));
      expect(dbService.queryAllCount, equals(1)); // Still 1!
    });

    test('addPosition invalidates cache and triggers reload', () async {
      final appState = AppState(dbService, receivePort);
      await appState.portfolio;
      expect(dbService.queryAllCount, equals(1));

      final newPosition = Position(
        symbol: 'ETH',
        units: 2.0,
        price: 300000.0,
        dateTime: DateTime(2023, 2, 1),
      );

      await appState.addPosition(newPosition);

      // queryAll was called again during reload
      expect(dbService.queryAllCount, equals(2));
      expect(appState.portfolioCached!.length, equals(2));
      expect(
        appState.portfolioCached!.map((c) => c.symbol).toList(),
        containsAll(['BTC', 'ETH']),
      );
    });

    test('deletePosition invalidates cache and triggers reload', () async {
      final appState = AppState(dbService, receivePort);
      await appState.portfolio;
      expect(dbService.queryAllCount, equals(1));

      await appState.deletePosition(1);

      // queryAll was called again during reload
      expect(dbService.queryAllCount, equals(2));
      expect(appState.portfolioCached!.isEmpty, isTrue);
    });

    test('updatePosition invalidates cache and triggers reload', () async {
      final appState = AppState(dbService, receivePort);
      await appState.portfolio;
      expect(dbService.queryAllCount, equals(1));

      final updatedPosition = Position(
        id: 1,
        symbol: 'BTC',
        units: 1.5,
        price: 4500000.0,
        dateTime: DateTime(2022, 1, 1),
      );

      await appState.updatePosition(updatedPosition);

      expect(dbService.queryAllCount, equals(2));
      expect(
        appState.portfolioCached!.first.positions.first.units,
        equals(1.5),
      );
    });
  });

  group('AppState connectivity & worker duration (Phase 3)', () {
    late ReceivePort receivePort;
    late ReceivePort workerReceivePort;
    late CountingFakeDatabaseService dbService;

    setUp(() {
      receivePort = ReceivePort();
      workerReceivePort = ReceivePort();
      dbService = CountingFakeDatabaseService();
    });

    tearDown(() {
      receivePort.close();
      workerReceivePort.close();
    });

    test('sends 30s duration when on wifi', () async {
      final fakeConnectivity =
          FakeConnectivity([ConnectivityResult.wifi]);
      final appState = AppState(
        dbService,
        receivePort,
        connectivity: fakeConnectivity,
      );

      final durationCompleter = Completer<Duration>();
      workerReceivePort.listen((msg) {
        if (msg is Duration && !durationCompleter.isCompleted) {
          durationCompleter.complete(msg);
        }
      });

      await appState.updateIsolateDuration(workerReceivePort.sendPort);
      final duration = await durationCompleter.future;
      expect(duration, equals(const Duration(seconds: 30)));
    });

    test('sends 60s duration when on mobile', () async {
      final fakeConnectivity =
          FakeConnectivity([ConnectivityResult.mobile]);
      final appState = AppState(
        dbService,
        receivePort,
        connectivity: fakeConnectivity,
      );

      final durationCompleter = Completer<Duration>();
      workerReceivePort.listen((msg) {
        if (msg is Duration && !durationCompleter.isCompleted) {
          durationCompleter.complete(msg);
        }
      });

      await appState.updateIsolateDuration(workerReceivePort.sendPort);
      final duration = await durationCompleter.future;
      expect(duration, equals(const Duration(seconds: 60)));
    });

    test('sends 120s duration when on other/none', () async {
      final fakeConnectivity =
          FakeConnectivity([ConnectivityResult.none]);
      final appState = AppState(
        dbService,
        receivePort,
        connectivity: fakeConnectivity,
      );

      final durationCompleter = Completer<Duration>();
      workerReceivePort.listen((msg) {
        if (msg is Duration && !durationCompleter.isCompleted) {
          durationCompleter.complete(msg);
        }
      });

      await appState.updateIsolateDuration(workerReceivePort.sendPort);
      final duration = await durationCompleter.future;
      expect(duration, equals(const Duration(seconds: 120)));
    });

    test('automatically updates duration on worker handshake and connectivity changes',
        () async {
      final fakeConnectivity =
          FakeConnectivity([ConnectivityResult.wifi]);
      AppState(
        dbService,
        receivePort,
        connectivity: fakeConnectivity,
      );

      final receivedDurations = <Duration>[];
      workerReceivePort.listen((msg) {
        if (msg is Duration) {
          receivedDurations.add(msg);
        }
      });

      // Handshake from worker
      receivePort.sendPort.send(
        FetchedMessage(sendPort: workerReceivePort.sendPort),
      );
      await Future.delayed(const Duration(milliseconds: 30));

      expect(receivedDurations, contains(const Duration(seconds: 30)));

      // Network changes from wifi to mobile
      fakeConnectivity.emit([ConnectivityResult.mobile]);
      await Future.delayed(const Duration(milliseconds: 30));

      expect(receivedDurations, contains(const Duration(seconds: 60)));
    });
  });
}

class FakeConnectivity implements Connectivity {
  List<ConnectivityResult> currentResults;
  final StreamController<List<ConnectivityResult>> _controller =
      StreamController<List<ConnectivityResult>>.broadcast();

  FakeConnectivity([this.currentResults = const [ConnectivityResult.wifi]]);

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => currentResults;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _controller.stream;

  void emit(List<ConnectivityResult> results) {
    currentResults = results;
    _controller.add(results);
  }
}
