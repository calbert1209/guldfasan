import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:guldfasan/widgets/total_profit.dart';

class Portfolio extends StatelessWidget {
  Portfolio(this._portfolio, this._prices);

  final Iterable<PositionCollection> _portfolio;
  final Map<String, int>? _prices;

  @override
  Widget build(BuildContext context) {
    final sortedPortfolio = _portfolio.toList()
      ..sort((a, b) {
        final cmp = a.symbol.toLowerCase().compareTo(b.symbol.toLowerCase());
        return cmp != 0 ? cmp : a.symbol.compareTo(b.symbol);
      });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TotalProfit(
          portfolio: _portfolio,
          prices: _prices,
        ),
        ...sortedPortfolio.map((collection) {
          final currentPrice = _prices?[collection.symbol]?.toDouble();
          return PositionCollectionDisplay(
            collection: collection,
            currentPrice: currentPrice,
          );
        }).toList(),
      ],
    );
  }
}
