import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/widgets/flexible_price_cell.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:guldfasan/widgets/shimmer_skeleton.dart';
import 'package:guldfasan/widgets/total_profit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
  group('ShimmerSkeleton', () {
    testWidgets('renders with specified dimensions and contains Shimmer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerSkeleton(width: 100.0, height: 30.0),
          ),
        ),
      );

      final finder = find.byType(ShimmerSkeleton);
      expect(finder, findsOneWidget);

      final size = tester.getSize(finder);
      expect(size.width, equals(100.0));
      expect(size.height, equals(30.0));

      expect(find.descendant(of: finder, matching: find.byType(Shimmer)),
          findsOneWidget);
    });
  });

  group('FlexiblePriceCell', () {
    testWidgets('renders text when text is supplied',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                FlexiblePriceCell(text: '12,345'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('12,345'), findsOneWidget);
    });

    testWidgets('renders child widget when child is supplied',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                FlexiblePriceCell(
                  child: const ShimmerSkeleton(width: 60, height: 20),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerSkeleton), findsOneWidget);
    });
  });

  group('TotalProfit', () {
    final positions = [
      Position(
        id: 1,
        symbol: 'BTC',
        units: 0.5,
        price: 4000000,
        dateTime: DateTime(2021, 1, 1),
      ),
    ];
    final portfolio = [
      PositionCollection(symbol: 'BTC', positions: positions),
    ];

    testWidgets('renders ShimmerSkeleton placeholders when prices is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TotalProfit(
              portfolio: portfolio,
              prices: null,
            ),
          ),
        ),
      );

      // Should render 2 shimmering skeleton placeholders for rate of return and total profit
      expect(find.byType(ShimmerSkeleton), findsNWidgets(2));
      // Should NOT render negative dummy calculations like -100.0%
      expect(find.text('-100.0%'), findsNothing);
      expect(find.text('-100%'), findsNothing);
    });

    testWidgets('renders calculated profit and percentage when prices are available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TotalProfit(
              portfolio: portfolio,
              prices: const {'BTC': 6000000},
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerSkeleton), findsNothing);
      expect(find.text('50.0%'), findsOneWidget);
      expect(find.text('1000000.00'), findsOneWidget);
    });
  });

  group('PositionCollectionDisplay with null price', () {
    final positions = [
      Position(
        id: 1,
        symbol: 'BTC',
        units: 0.002,
        price: 4000000,
        dateTime: DateTime(2021, 5, 10),
      ),
    ];
    final collection = PositionCollection(symbol: 'BTC', positions: positions);

    testWidgets('renders ShimmerSkeleton placeholders when currentPrice is null',
        (WidgetTester tester) async {
      final dummyReceivePort = ReceivePort();
      addTearDown(() => dummyReceivePort.close());
      final appState = AppState(FakeDatabaseService(), dummyReceivePort);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<AppState>.value(
              value: appState,
              child: PositionCollectionDisplay(
                collection: collection,
                currentPrice: null,
              ),
            ),
          ),
        ),
      );

      // Symbol is still visible
      expect(find.text('BTC'), findsOneWidget);
      // Date is still visible
      expect(find.text('2021-05-10'), findsOneWidget);

      // Skeletons are displayed for header price, header percent, and position diff cell (total 3)
      expect(find.byType(ShimmerSkeleton), findsNWidgets(3));

      // No dummy -1 or negative placeholder text
      expect(find.text('-1'), findsNothing);
      expect(find.text('-¥1'), findsNothing);
    });

    testWidgets('renders real values when currentPrice is provided',
        (WidgetTester tester) async {
      final dummyReceivePort = ReceivePort();
      addTearDown(() => dummyReceivePort.close());
      final appState = AppState(FakeDatabaseService(), dummyReceivePort);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<AppState>.value(
              value: appState,
              child: PositionCollectionDisplay(
                collection: collection,
                currentPrice: 6000000.0,
              ),
            ),
          ),
        ),
      );

      expect(find.text('BTC'), findsOneWidget);
      expect(find.byType(ShimmerSkeleton), findsNothing);
      expect(find.text('12,000'), findsOneWidget);
      expect(find.text('50.00%'), findsOneWidget);
    });
  });
}
