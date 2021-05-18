import 'package:flutter/material.dart';

class CryptoPosition {
  CryptoPosition(
      {@required this.units, @required this.price, @required this.dateTime});

  final double units;
  final double price;
  final DateTime dateTime;

  double profitOrLoss(double current) => current - price;
}

class CryptoPositionCollection {
  CryptoPositionCollection({@required this.symbol, @required this.positions});

  final String symbol;
  final List<CryptoPosition> positions;

  List<CryptoPosition> byPurchasePrice({bool desc = true}) {
    int sign = desc ? -1 : 1;
    return positions.sublist(0)
      ..sort((a, b) => (a.price - b.price).toInt() * sign);
  }
}
