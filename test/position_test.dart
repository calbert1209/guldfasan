import 'dart:math';

import 'package:test/test.dart';
import 'package:guldfasan/models/position.dart';

void main() {
  group('Position', () {
    final position = Position(
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

  group('PositionCollection', () {
    group('byPurchasePrice', () {
      var now = DateTime.now();
      var positions = [
        Position(symbol: 'BTC', units: 1.0, price: 10.0, dateTime: now),
        Position(symbol: 'BTC', units: 1.0, price: 11.0, dateTime: now),
        Position(symbol: 'BTC', units: 1.0, price: 9.0, dateTime: now),
        Position(symbol: 'BTC', units: 1.0, price: 12.5, dateTime: now),
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
    });
  });
}
