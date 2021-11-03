import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';

class CashFlow {
  CashFlow(this.cashIn, this.cashOut);

  final double cashIn;
  final double cashOut;

  double returnOnInvestment() => cashOut - cashIn;
  double rateOfReturn() => (cashOut - cashIn) / cashIn;

  CashFlow add(double otherCashIn, otherCashOut) =>
      new CashFlow(cashIn + otherCashIn, cashOut + otherCashOut);

  CashFlow combine(CashFlow other) =>
      new CashFlow(cashIn + other.cashIn, cashOut + other.cashOut);
}

CashFlow tallyCashFlow(PositionCollection collection, int price) {
  final initial = new CashFlow(0, 0);
  return collection.positions.fold<CashFlow>(initial, (prev, position) {
    final purchaseValue = position.units * position.price;
    final currentValue = position.units * price;
    return prev.add(purchaseValue, currentValue);
  });
}

CashFlow reduceTotalProfit(
  Iterable<PositionCollection> portfolio,
  Map<String, int> prices,
) {
  var total = new CashFlow(0, 0);
  for (var collection in portfolio) {
    final currentPrice = prices[collection.symbol]!;
    final collectionCashFlow = tallyCashFlow(collection, currentPrice);
    total = total.combine(collectionCashFlow);
  }
  return total;
}

class TotalProfit extends StatelessWidget {
  TotalProfit({required portfolio, required prices})
      : cashFlow = reduceTotalProfit(portfolio, prices);

  final CashFlow cashFlow;

  @override
  Widget build(BuildContext context) {
    final totalProfit = cashFlow.returnOnInvestment();
    final rateOfReturn = cashFlow.rateOfReturn() * 100;
    var color = colorForSign(totalProfit);
    return Padding(
      padding: PositionCollectionInsets,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${rateOfReturn.toStringAsFixed(1)}%',
            style: TextStyle(
              fontFamily: 'KoHo',
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
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
