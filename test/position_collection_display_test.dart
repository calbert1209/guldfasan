import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:provider/provider.dart';
import 'dart:isolate';

void main() {
  testWidgets('PositionCollectionDisplay header shows symbol and total current value on left, percent on right',
      (WidgetTester tester) async {
    final positions = [
      Position(
        id: 1,
        symbol: 'BTC',
        units: 0.002,
        price: 4000000, // cashIn = 8,000
        dateTime: DateTime(2021, 5, 10),
      ),
      Position(
        id: 2,
        symbol: 'BTC',
        units: 0.001,
        price: 5000000, // cashIn = 5,000
        dateTime: DateTime(2021, 6, 15),
      ),
    ];
    // Total units = 0.003
    // At currentPrice = 6,000,000:
    // Total cashOut = 0.003 * 6,000,000 = 18,000
    // Total cashIn = 8,000 + 5,000 = 13,000
    // ROI = 18,000 - 13,000 = 5,000
    // Rate of return = 5,000 / 13,000 ~= 38.46%

    final collection = PositionCollection(
      symbol: 'BTC',
      positions: positions,
    );

    final dummyReceivePort = ReceivePort();
    addTearDown(() => dummyReceivePort.close());
    final appState = AppState(DatabaseService(), dummyReceivePort);

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

    // Verify symbol 'BTC' is displayed
    expect(find.text('BTC'), findsOneWidget);

    // Verify total current value of positions (18,000) is displayed in header, NOT unit price (6,000,000)
    expect(find.text('18,000'), findsOneWidget);
    expect(find.text('6,000,000'), findsNothing);

    // Verify total percent return (38.46%) is displayed on header
    expect(find.text('38.46%'), findsOneWidget);

    // Verify all header texts align to the exact same alphabetic baseline
    final symbolRender = tester.renderObject<RenderParagraph>(find.text('BTC'));
    final priceRender = tester.renderObject<RenderParagraph>(find.text('18,000'));
    final percentRender = tester.renderObject<RenderParagraph>(find.text('38.46%'));

    final symbolBaseline = tester.getTopLeft(find.text('BTC')).dy +
        symbolRender.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    final priceBaseline = tester.getTopLeft(find.text('18,000')).dy +
        priceRender.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    final percentBaseline = tester.getTopLeft(find.text('38.46%')).dy +
        percentRender.computeDistanceToActualBaseline(TextBaseline.alphabetic);

    expect(priceBaseline, equals(symbolBaseline));
    expect(percentBaseline, equals(symbolBaseline));

    // Verify position diffs are rendered
    // Position 1: (6,000,000 - 4,000,000) * 0.002 = +4,000
    expect(find.text('4,000'), findsOneWidget);
    // Position 2: (6,000,000 - 5,000,000) * 0.001 = +1,000
    expect(find.text('1,000'), findsOneWidget);
  });
}
