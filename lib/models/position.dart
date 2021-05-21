class PositionKey {
  static const tablePosition = 'position';
  static const id = '_id';
  static const symbol = 'symbol';
  static const units = 'units';
  static const price = 'price';
  static const dateTime = 'datetime';
}

class Position {
  Position(
      {required this.id,
      required this.symbol,
      required this.units,
      required this.price,
      required this.dateTime});

  final int id;
  final String symbol;
  final double units;
  final double price;
  final DateTime dateTime;

  factory Position.fromMap(Map<String, dynamic> json) {
    return Position(
      id: json[{PositionKey.id}] as int,
      symbol: json[PositionKey.symbol] as String,
      units: json[PositionKey.units] as double,
      price: json[PositionKey.price] as double,
      dateTime: DateTime.parse(json[PositionKey.dateTime] as String),
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        PositionKey.id: this.id,
        PositionKey.symbol: this.symbol,
        PositionKey.units: this.units,
        PositionKey.price: this.price,
        PositionKey.dateTime: this.dateTime.toIso8601String(),
      };

  double profitOrLoss(double current) => (current - price) * units;
}

class PositionCollection {
  PositionCollection({required this.symbol, required this.positions});

  final String symbol;
  final List<Position> positions;

  List<Position> byPurchasePrice({bool desc = true}) {
    int sign = desc ? -1 : 1;
    return positions.sublist(0)
      ..sort((a, b) => (a.price - b.price).toInt() * sign);
  }
}
