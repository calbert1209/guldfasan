import 'package:guldfasan/models/position.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String _createTable = '''
CREATE TABLE ${PositionKey.tablePosition}(
  ${PositionKey.id} integer primary key autoincrement,
  ${PositionKey.symbol} text not null,
  ${PositionKey.units} real not null,
  ${PositionKey.price} real not null,
  ${PositionKey.dateTime} text not null)
''';

class DatabaseService {
  DatabaseService._(this._database);

  final Database _database;

  static Future<DatabaseService> initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'guldfasan.db');
    final database = await openDatabase(
      path,
      onCreate: (db, version) async {
        print('creating db');
        return db.execute(_createTable);
      },
      onOpen: (db) {
        print('db opened');
      },
      version: 1,
    );

    return DatabaseService._(database);

    // Future<Position> insert(Position position) async {
    // position.toMap()
    // }
  }
}
