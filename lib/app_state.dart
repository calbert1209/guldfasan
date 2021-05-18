import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';

class AppState with ChangeNotifier {
  List<CryptoPositionCollection> portfolio = [
    new CryptoPositionCollection(
      symbol: "BTC",
      positions: [
        new CryptoPosition(
          units: 1.0,
          price: 400000,
          dateTime: DateTime(2019, 4, 1, 9, 30),
        ),
        new CryptoPosition(
          units: 1.0,
          price: 600000,
          dateTime: DateTime(2020, 12, 12, 10, 30),
        ),
      ],
    ),
    new CryptoPositionCollection(
      symbol: "ETH",
      positions: [
        new CryptoPosition(
          units: 1.0,
          price: 30000,
          dateTime: DateTime(2018, 4, 20, 9, 30),
        ),
      ],
    ),
  ];
}
