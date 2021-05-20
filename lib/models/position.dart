class Position {
  Position({required this.units, required this.price, required this.dateTime});

  final double units;
  final double price;
  final DateTime dateTime;

  double profitOrLoss(double current) => current - price;
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
