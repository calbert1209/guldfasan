import 'package:flutter/material.dart';
import 'package:guldfasan/models/cash_flow.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:guldfasan/widgets/shimmer_skeleton.dart';

class TotalProfit extends StatelessWidget {
  TotalProfit({required this.portfolio, required this.prices})
      : cashFlow =
            prices != null ? tallyPortfolioCashFlow(portfolio, prices) : null;

  final Iterable<PositionCollection> portfolio;
  final Map<String, int>? prices;
  final CashFlow? cashFlow;

  @override
  Widget build(BuildContext context) {
    if (cashFlow == null) {
      return Padding(
        padding: PositionCollectionInsets,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            ShimmerSkeleton(width: 120, height: 42),
            ShimmerSkeleton(width: 140, height: 42),
          ],
        ),
      );
    }

    final totalProfit = cashFlow!.returnOnInvestment();
    final rateOfReturn =
        cashFlow!.cashIn > 0 ? (cashFlow!.rateOfReturn() * 100) : 0.0;
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
