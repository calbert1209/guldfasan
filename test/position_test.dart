import 'dart:math';

import 'package:test/test.dart';
import 'package:guldfasan/models/position.dart';

void main() {
  group('Position', () {
    final position = Position(
      id: 777,
      symbol: 'BTC',
      units: 1.0,
      price: 5.0,
      dateTime: DateTime.now(),
    );

    [
      MapEntry('should return + profit', Point(6.0, 1.0)),
      MapEntry('should return - profit (loss)', Point(4.0, -1.0)),
      MapEntry('should return 0 profit', Point(5.0, 0.0)),
    ].forEach((entry) {
      test(entry.key, () {
        expect(position.profitOrLoss(entry.value.x), entry.value.y);
      });
    });
  });

  group('Position serialization', () {
    test('round-trip serialization toMap and fromMap', () {
      final original = Position(
        id: 42,
        symbol: 'BTC',
        units: 1.5,
        price: 50000.25,
        dateTime: DateTime.utc(2023, 1, 15, 10, 30),
      );
      final map = original.toMap();
      final restored = Position.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.symbol, original.symbol);
      expect(restored.units, original.units);
      expect(restored.price, original.price);
      expect(restored.dateTime, original.dateTime);
      expect(restored.toMap(), map);
    });
  });

  group('PositionCollection', () {
    group('byPurchasePrice', () {
      var now = DateTime.now();
      var positions = [
        Position(
          id: 100,
          symbol: 'BTC',
          units: 1.0,
          price: 10.0,
          dateTime: now,
        ),
        Position(
          id: 101,
          symbol: 'BTC',
          units: 1.0,
          price: 11.0,
          dateTime: now,
        ),
        Position(
          id: 102,
          symbol: 'BTC',
          units: 1.0,
          price: 9.0,
          dateTime: now,
        ),
        Position(
          id: 103,
          symbol: 'BTC',
          units: 1.0,
          price: 12.5,
          dateTime: now,
        ),
      ];
      var collection = PositionCollection(symbol: 'BTC', positions: positions);
      test('should return new instance', () {
        var byPrice = collection.byPurchasePrice();
        expect(identical(byPrice, collection), false);
      });

      test('should return list ordered descending', () {
        var byPriceDescending = collection.byPurchasePrice();
        var pricesString = byPriceDescending.map((it) => it.price).join(",");
        expect(pricesString, "12.5,11.0,10.0,9.0");
      });

      test('should return list ordered ascending', () {
        var byPriceDescending = collection.byPurchasePrice(desc: false);
        var pricesString = byPriceDescending.map((it) => it.price).join(",");
        expect(pricesString, "9.0,10.0,11.0,12.5");
      });

      test('should sort fractional prices accurately', () {
        final fractionalPositions = [
          Position(
            id: 201,
            symbol: 'BTC',
            units: 1.0,
            price: 10.2,
            dateTime: now,
          ),
          Position(
            id: 202,
            symbol: 'BTC',
            units: 1.0,
            price: 10.8,
            dateTime: now,
          ),
          Position(
            id: 203,
            symbol: 'BTC',
            units: 1.0,
            price: 10.5,
            dateTime: now,
          ),
        ];
        final col = PositionCollection(
          symbol: 'BTC',
          positions: fractionalPositions,
        );

        final desc = col.byPurchasePrice(desc: true);
        expect(desc.map((p) => p.price).toList(), [10.8, 10.5, 10.2]);

        final asc = col.byPurchasePrice(desc: false);
        expect(asc.map((p) => p.price).toList(), [10.2, 10.5, 10.8]);
      });
    });
  });
}
