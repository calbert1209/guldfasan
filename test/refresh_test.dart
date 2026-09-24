import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/pages/home_page.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/services/fetcher.dart';
import 'package:provider/provider.dart';

class FakeDatabaseService extends DatabaseService {
  final List<Map<String, dynamic>> positions;
  FakeDatabaseService([this.positions = const []]);

  @override
  Future<List<Map<String, dynamic>>> queryAll() async => positions;

  @override
  Future<int> insert(Position position) async => 1;

  @override
  Future<int> delete(int id) async => 1;

  @override
  Future<int> update(Position position) async => 1;
}

void main() {
  group('AppState.refreshPrices', () {
    test('sends "immediate" to worker and completes when FetchedMessage arrives', () async {
      final appReceivePort = ReceivePort();
      final workerReceivePort = ReceivePort();
      addTearDown(() {
        appReceivePort.close();
        workerReceivePort.close();
      });

      final appState = AppState(FakeDatabaseService(), appReceivePort);

      // Simulate worker initial handshake message
      appReceivePort.sendPort.send(
        FetchedMessage(sendPort: workerReceivePort.sendPort),
      );
      await Future.delayed(const Duration(milliseconds: 20));
      expect(appState.fromWorker, equals(workerReceivePort.sendPort));

      // Listen for "immediate" signal on worker port
      final workerMessageCompleter = Completer<dynamic>();
      workerReceivePort.listen((message) {
        if (!workerMessageCompleter.isCompleted) {
          workerMessageCompleter.complete(message);
        }
      });

      bool notified = false;
      appState.addListener(() {
        notified = true;
      });

      final refreshFuture = appState.refreshPrices();

      final receivedWorkerMsg = await workerMessageCompleter.future;
      expect(receivedWorkerMsg, equals('immediate'));

      // Worker responds with price data
      appReceivePort.sendPort.send(
        FetchedMessage(prices: {'BTC': 9500000, 'ETH': 450000, 'XAU': 29000}),
      );

      await refreshFuture;
      expect(notified, isTrue);
    });

    test('gracefully completes and notifies listeners on timeout', () async {
      final appReceivePort = ReceivePort();
      addTearDown(() => appReceivePort.close());

      final appState = AppState(FakeDatabaseService(), appReceivePort);

      bool notified = false;
      appState.addListener(() {
        notified = true;
      });

      await appState.refreshPrices(timeout: const Duration(milliseconds: 50));
      expect(notified, isTrue);
    });
  });

  group('HomePage RefreshIndicator', () {
    testWidgets('contains RefreshIndicator with AlwaysScrollableScrollPhysics ListView',
        (WidgetTester tester) async {
      final appReceivePort = ReceivePort();
      addTearDown(() => appReceivePort.close());

      final appState = AppState(FakeDatabaseService(), appReceivePort);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            primaryColor: const Color(0xFF6B4226),
          ),
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: HomePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final refreshIndicatorFinder = find.byType(RefreshIndicator);
      expect(refreshIndicatorFinder, findsOneWidget);

      final refreshIndicator =
          tester.widget<RefreshIndicator>(refreshIndicatorFinder);
      expect(refreshIndicator.color, equals(const Color(0xFF6B4226)));
      expect(refreshIndicator.backgroundColor, equals(Colors.brown.shade50));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);

      final listView = tester.widget<ListView>(listViewFinder);
      expect(listView.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('RefreshIndicator onRefresh triggers appState.refreshPrices',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final appReceivePort = ReceivePort();
        final workerReceivePort = ReceivePort();
        addTearDown(() {
          appReceivePort.close();
          workerReceivePort.close();
        });

        final appState = AppState(FakeDatabaseService(), appReceivePort);

        // Register worker port
        appReceivePort.sendPort.send(
          FetchedMessage(sendPort: workerReceivePort.sendPort),
        );
        await Future.delayed(const Duration(milliseconds: 20));

        final workerMessageCompleter = Completer<dynamic>();
        workerReceivePort.listen((message) {
          if (!workerMessageCompleter.isCompleted) {
            workerMessageCompleter.complete(message);
          }
        });

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<AppState>.value(
              value: appState,
              child: HomePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final indicator =
            tester.widget<RefreshIndicator>(find.byType(RefreshIndicator));
        final refreshFuture = indicator.onRefresh();

        final msg = await workerMessageCompleter.future;
        expect(msg, equals('immediate'));

        appReceivePort.sendPort.send(
          FetchedMessage(prices: {'BTC': 9500000}),
        );

        await refreshFuture;
      });
    });
  });
}
