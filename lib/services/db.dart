import 'dart:async';
import 'dart:io';

import 'package:guldfasan/models/position.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final String _tableName = PositionKey.tablePosition;
  DatabaseService._(this._database);

  final Database _database;

  static _onCreate(Database db, int version) async {
    final String _createTable = '''
CREATE TABLE $_tableName(
  ${PositionKey.id} integer primary key autoincrement,
  ${PositionKey.symbol} text not null,
  ${PositionKey.units} real not null,
  ${PositionKey.price} real not null,
  ${PositionKey.dateTime} text not null)
''';
    print('creating db');
    await db.execute(_createTable);
    await _batchInsert(db, kDummyEntriesJson);
  }

  static Future<List<Object?>> _batchInsert(
    Database db,
    Iterable<Map<String, Object?>> positions,
  ) async {
    var batch = db.batch();
    for (var position in positions) {
      batch.insert(_tableName, position);
    }
    return batch.commit(continueOnError: true);
  }

  static Future<DatabaseService> initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'guldfasan.db');

    try {
      await Directory(dbPath).create(recursive: true);
    } catch (e) {
      print(e);
    }

    final database = await openDatabase(
      path,
      onCreate: _onCreate,
      onOpen: (db) {
        print('db opened');
      },
      version: 1,
    );

    return DatabaseService._(database);
  }

  Future<int> insert(Position position) async {
    return this._database.insert(_tableName, position.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAll() {
    return this._database.query(_tableName);
  }

  // Future<List<Object?>> batchInsert(Iterable<Position> positions) async {
  //   final positionMaps = positions.map((p) => p.toMap());
  //   return DatabaseService._batchInsert(this._database, positionMaps);
  // }
}
