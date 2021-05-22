import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';

class Portfolio extends StatelessWidget {
  Portfolio(this._portfolio);

  final Iterable<PositionCollection> _portfolio;
  final Map<String, double> prices = {"BTC": 543219.77, "ETH": 35000.45};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _portfolio.map((collection) {
          return PositionCollectionDisplay(
            collection: collection,
            currentPrice: prices[collection.symbol]!,
          );
        }).toList(),
      ),
    );
  }
}
