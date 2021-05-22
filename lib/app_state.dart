import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';

class AppState with ChangeNotifier {
  AppState(this.dbService);

  final DatabaseService dbService;

  static Iterable<PositionCollection> _collatePortfolio() {
    var map = kDummyEntriesJson
        .map((entry) => Position.fromMap(entry))
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

  Future<Iterable<PositionCollection>> positions() async {
    var positionMaps = await dbService.queryAll();
    var map = positionMaps
        .map((entry) => Position.fromMap(entry))
        .fold<Map<String, PositionCollection>>(
      Map<String, PositionCollection>(),
      (map, entry) {
        if (!map.containsKey(entry.symbol)) {
          map[entry.symbol] =
              PositionCollection(symbol: entry.symbol, positions: []);
        }

        map[entry.symbol]!.positions.add(entry);
        return map;
      },
    );
    return map.values;
  }
}
