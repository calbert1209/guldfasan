import 'package:flutter/material.dart';
import 'package:guldfasan/models/cash_flow.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';

class TotalProfit extends StatelessWidget {
  TotalProfit({required portfolio, required prices})
      : cashFlow = tallyPortfolioCashFlow(portfolio, prices);

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
