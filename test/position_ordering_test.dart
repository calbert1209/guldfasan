import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/pages/home_page.dart';
import 'package:guldfasan/pages/position_data_view_page.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/widgets/data_view_card.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:provider/provider.dart';

class FakeOrderingDatabaseService extends DatabaseService {
  final List<Map<String, dynamic>> positions;
  FakeOrderingDatabaseService(this.positions);

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
  final outOfOrderPositions = [
    Position(
      id: 1,
      symbol: 'XAU',
      units: 10.0,
      price: 15000,
      dateTime: DateTime(2022, 6, 1),
    ),
    Position(
      id: 2,
      symbol: 'BTC',
      units: 0.5,
      price: 5000000,
      dateTime: DateTime(2021, 3, 1),
    ),
    Position(
      id: 3,
      symbol: 'ETH',
      units: 2.0,
      price: 300000,
      dateTime: DateTime(2020, 8, 1),
    ),
    Position(
      id: 4,
      symbol: 'BTC',
      units: 0.1,
      price: 4000000,
      dateTime: DateTime(2019, 1, 1), // Earlier BTC date
    ),
    Position(
      id: 5,
      symbol: 'XAU',
      units: 5.0,
      price: 12000,
      dateTime: DateTime(2018, 5, 1), // Earlier XAU date
    ),
  ];

  group('AppState.portfolio ordering', () {
    test('orders collections A to Z and positions within each collection oldest to newest',
        () async {
      final dummyReceivePort = ReceivePort();
      addTearDown(() => dummyReceivePort.close());

      final dbService = FakeOrderingDatabaseService(
        outOfOrderPositions.map((p) => p.toMap()).toList(),
      );
      final appState = AppState(dbService, dummyReceivePort);

      final collections = (await appState.portfolio).toList();

      // Collections ordered A to Z
      expect(collections.map((c) => c.symbol).toList(), ['BTC', 'ETH', 'XAU']);

      // BTC positions ordered oldest to newest (2019, 2021)
      expect(
        collections[0].positions.map((p) => p.dateTime).toList(),
        [DateTime(2019, 1, 1), DateTime(2021, 3, 1)],
      );

      // ETH positions ordered oldest to newest (2020)
      expect(
        collections[1].positions.map((p) => p.dateTime).toList(),
        [DateTime(2020, 8, 1)],
      );

      // XAU positions ordered oldest to newest (2018, 2022)
      expect(
        collections[2].positions.map((p) => p.dateTime).toList(),
        [DateTime(2018, 5, 1), DateTime(2022, 6, 1)],
      );
    });
  });

  group('Portfolio & HomePage ordering', () {
    testWidgets('renders collections alphabetically and positions oldest to newest',
        (WidgetTester tester) async {
      final dummyReceivePort = ReceivePort();
      addTearDown(() => dummyReceivePort.close());

      final dbService = FakeOrderingDatabaseService(
        outOfOrderPositions.map((p) => p.toMap()).toList(),
      );
      final appState = AppState(dbService, dummyReceivePort);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: HomePage(),
          ),
        ),
      );

      // Allow FutureBuilder and initial frame to render
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify PositionCollectionDisplay widgets are ordered alphabetically: BTC, ETH, XAU
      final displays = tester
          .widgetList<PositionCollectionDisplay>(
              find.byType(PositionCollectionDisplay))
          .toList();
      expect(displays.length, equals(3));
      expect(displays[0].collection.symbol, equals('BTC'));
      expect(displays[1].collection.symbol, equals('ETH'));
      expect(displays[2].collection.symbol, equals('XAU'));

      // Check vertical positioning: BTC is above ETH, ETH is above XAU
      final btcTop = tester.getTopLeft(find.text('BTC')).dy;
      final ethTop = tester.getTopLeft(find.text('ETH')).dy;
      final xauTop = tester.getTopLeft(find.text('XAU')).dy;
      expect(btcTop, lessThan(ethTop));
      expect(ethTop, lessThan(xauTop));

      // Check dates within BTC: 2019-01-01 is above 2021-03-01
      final btc2019Top = tester.getTopLeft(find.text('2019-01-01')).dy;
      final btc2021Top = tester.getTopLeft(find.text('2021-03-01')).dy;
      expect(btc2019Top, lessThan(btc2021Top));

      // Check dates within XAU: 2018-05-01 is above 2022-06-01
      final xau2018Top = tester.getTopLeft(find.text('2018-05-01')).dy;
      final xau2022Top = tester.getTopLeft(find.text('2022-06-01')).dy;
      expect(xau2018Top, lessThan(xau2022Top));
    });
  });

  group('PositionDataViewPage ordering', () {
    testWidgets('mirrors alphabetical collections and oldest-to-newest positions order',
        (WidgetTester tester) async {
      final dummyReceivePort = ReceivePort();
      addTearDown(() => dummyReceivePort.close());

      final dbService = FakeOrderingDatabaseService(
        outOfOrderPositions.map((p) => p.toMap()).toList(),
      );
      final appState = AppState(dbService, dummyReceivePort);

      await tester.pumpWidget(
        MaterialApp(
          home: PositionDataViewPage(
            positions: appState.portfolio,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final cards = tester
          .widgetList<DataViewCard>(find.byType(DataViewCard))
          .toList();
      expect(cards.length, equals(5));

      // Cards should be ordered:
      // BTC 2019-01-01
      // BTC 2021-03-01
      // ETH 2020-08-01
      // XAU 2018-05-01
      // XAU 2022-06-01
      expect(cards[0].position.symbol, equals('BTC'));
      expect(cards[0].position.dateTime, equals(DateTime(2019, 1, 1)));

      expect(cards[1].position.symbol, equals('BTC'));
      expect(cards[1].position.dateTime, equals(DateTime(2021, 3, 1)));

      expect(cards[2].position.symbol, equals('ETH'));
      expect(cards[2].position.dateTime, equals(DateTime(2020, 8, 1)));

      expect(cards[3].position.symbol, equals('XAU'));
      expect(cards[3].position.dateTime, equals(DateTime(2018, 5, 1)));

      expect(cards[4].position.symbol, equals('XAU'));
      expect(cards[4].position.dateTime, equals(DateTime(2022, 6, 1)));
    });
  });
}
