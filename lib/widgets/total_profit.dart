import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';

double reduceCollectionProfit(PositionCollection collection, int price) {
  return collection.positions.fold<double>(0, (prev, position) {
    final purchaseValue = position.units * position.price;
    final currentValue = position.units * price;
    return prev + currentValue - purchaseValue;
  });
}

double reduceTotalProfit(
  Iterable<PositionCollection> portfolio,
  Map<String, int> prices,
) {
  var total = 0.0;
  for (var collection in portfolio) {
    final currentPrice = prices[collection.symbol]!;
    final profit = reduceCollectionProfit(collection, currentPrice);
    total += profit;
  }
  return total;
}

class TotalProfit extends StatelessWidget {
  TotalProfit({required portfolio, required prices})
      : totalProfit = reduceTotalProfit(portfolio, prices);

  final double totalProfit;

  @override
  Widget build(BuildContext context) {
    var color = colorForSign(totalProfit);
    return Padding(
      padding: PositionCollectionInsets,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            totalProfit.toStringAsFixed(2),
            style: TextStyle(
              fontFamily: 'KoHo',
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
