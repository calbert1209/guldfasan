import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/crypto_collection_display.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final Map<String, double> prices = {"BTC": 543219.77, "ETH": 35000.45};
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              appState.portfolio.map((CryptoPositionCollection collection) {
            return CryptoCollectionDisplay(
              collection: collection,
              currentPrice: prices[collection.symbol],
            );
          }).toList(),
        ),
      ),
    );
  }
}
