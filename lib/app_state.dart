import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';

class AppState with ChangeNotifier {
  static Iterable<PositionCollection> _collatePortfolio() {
    var map = _dummyEntriesJson
        .map((entry) => Position.fromJson(entry))
        .fold<Map<String, PositionCollection>>(
            Map<String, PositionCollection>(), (map, entry) {
      if (!map.containsKey(entry.symbol)) {
        map[entry.symbol] =
            PositionCollection(symbol: entry.symbol, positions: []);
      }

      map[entry.symbol]!.positions.add(entry);
      return map;
    });
    return map.values;
  }

  List<PositionCollection> portfolio = _collatePortfolio().toList();
}

Iterable<Map<String, dynamic>> _dummyEntriesJson = [
  Position(
      id: 0,
      symbol: 'BTC',
      units: 1.0,
      price: 400000,
      dateTime: DateTime(2019, 4, 1, 9, 30)),
  Position(
      id: 1,
      symbol: 'BTC',
      units: 1.0,
      price: 600000,
      dateTime: DateTime(2020, 12, 12, 10, 30)),
  Position(
      id: 2,
      symbol: 'ETH',
      units: 1.0,
      price: 30000,
      dateTime: DateTime(2018, 4, 20, 9, 30)),
].map((it) => it.toJson());
