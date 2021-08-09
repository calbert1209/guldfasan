import 'dart:async';
import 'dart:io';

import 'package:guldfasan/models/position.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final String _tableName = PositionKey.tablePosition;

  late Database _database;
  bool _isOpen = false;

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

  Future<void> _ensureOpened() {
    if (_isOpen) {
      return Future.value();
    }

    return _lazyInitialize();
  }

  Future<void> _lazyInitialize() async {
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

    this._database = database;
    this._isOpen = true;
    return;
  }

  Future<int> insert(Position position) async {
    await _ensureOpened();
    return this._database.insert(_tableName, position.toMap());
  }

  Future<int> delete(int id) async {
    await _ensureOpened();
    return _database.delete(
      _tableName,
      where: '${PositionKey.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Position position) async {
    assert(position.id != null);

    await _ensureOpened();
    return _database.update(
      _tableName,
      position.toMap(),
      where: '${PositionKey.id} = ?',
      whereArgs: [position.id],
    );
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    await _ensureOpened();
    return this._database.query(_tableName);
  }
}
