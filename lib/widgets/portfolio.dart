import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:guldfasan/widgets/total_profit.dart';

class Portfolio extends StatelessWidget {
  Portfolio(this._portfolio, this._prices);

  final Iterable<PositionCollection> _portfolio;
  final Map<String, int> _prices;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TotalProfit(
          portfolio: _portfolio,
          prices: _prices,
        ),
        ..._portfolio.map((collection) {
          return PositionCollectionDisplay(
            collection: collection,
            currentPrice: _prices[collection.symbol]!.toDouble(),
          );
        }).toList(),
      ],
    );
  }
}
