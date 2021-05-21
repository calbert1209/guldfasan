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

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json["id"] as int,
      symbol: json["symbol"] as String,
      units: json["units"] as double,
      price: json["price"] as double,
      dateTime: DateTime.parse(json["date-time"] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'symbol': this.symbol,
        'units': this.units,
        'price': this.price,
        'date-time': this.dateTime.toIso8601String(),
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
