import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';

class AppState with ChangeNotifier {
  static Iterable<CryptoPositionCollection> _collatePortfolio() {
    var map = _dummyEntriesJson
        .map((entry) => PortfolioEntry.fromJson(entry))
        .fold<Map<String, CryptoPositionCollection>>(
            Map<String, CryptoPositionCollection>(), (map, entry) {
      if (!map.containsKey(entry.symbol)) {
        map[entry.symbol] =
            CryptoPositionCollection(symbol: entry.symbol, positions: []);
      }

      map[entry.symbol].positions.add(entry.toPosition());
      return map;
    });
    return map.values;
  }

  List<CryptoPositionCollection> portfolio = _collatePortfolio().toList();
}

class PortfolioEntry {
  PortfolioEntry({
    @required this.symbol,
    @required this.units,
    @required this.price,
    @required this.dateTime,
  });

  final String symbol;
  final double units;
  final double price;
  final DateTime dateTime;

  factory PortfolioEntry.fromJson(Map<String, dynamic> json) {
    return PortfolioEntry(
      symbol: json["symbol"] as String,
      units: json["units"] as double,
      price: json["price"] as double,
      dateTime: DateTime.parse(json["date-time"] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'symbol': this.symbol,
        'units': this.units,
        'price': this.price,
        'date-time': this.dateTime.toIso8601String(),
      };

  CryptoPosition toPosition() =>
      CryptoPosition(units: units, price: price, dateTime: dateTime);
}

Iterable<Map<String, dynamic>> _dummyEntriesJson = [
  PortfolioEntry(
      symbol: 'BTC',
      units: 1.0,
      price: 400000,
      dateTime: DateTime(2019, 4, 1, 9, 30)),
  PortfolioEntry(
      symbol: 'BTC',
      units: 1.0,
      price: 600000,
      dateTime: DateTime(2020, 12, 12, 10, 30)),
  PortfolioEntry(
      symbol: 'ETH',
      units: 1.0,
      price: 30000,
      dateTime: DateTime(2018, 4, 20, 9, 30)),
].map((it) => it.toJson());
