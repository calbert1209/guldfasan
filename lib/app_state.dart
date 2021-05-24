import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/db.dart';

class AppState with ChangeNotifier {
  AppState(this.dbService, this.receivePort);

  final DatabaseService dbService;
  final ReceivePort receivePort;

  Future<Iterable<PositionCollection>> portfolio() async {
    var positionMaps = await dbService.queryAll();
    print("got data from db. entry count: ${positionMaps.length}");
    var map = positionMaps
        .map((entry) => Position.fromMap(entry))
        .fold<Map<String, PositionCollection>>(
      Map<String, PositionCollection>(),
      (map, entry) {
        if (!map.containsKey(entry.symbol)) {
          map[entry.symbol] = PositionCollection(
            symbol: entry.symbol,
            positions: [],
          );
        }

        map[entry.symbol]!.positions.add(entry);
        return map;
      },
    );
    return map.values;
  }
}
