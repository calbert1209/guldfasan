import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
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

class CryptoCollectionDisplay extends StatelessWidget {
  CryptoCollectionDisplay(
      {@required this.collection, @required this.currentPrice});

  final CryptoPositionCollection collection;
  final double currentPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
          child: Row(
            children: [
              Text(collection.symbol, style: TextStyle(fontSize: 32.0)),
            ],
          ),
        ),
        ...this.collection.positions.map((CryptoPosition position) {
          return CryptoAssetPosition(
            position: position,
            currentPrice: currentPrice,
          );
        }).toList(),
      ],
    );
  }
}

class CryptoAssetPosition extends StatelessWidget {
  CryptoAssetPosition({Key key, this.position, this.currentPrice});

  final CryptoPosition position;
  final double currentPrice;

  @override
  Widget build(BuildContext context) {
    final diff = (currentPrice - position.price) * position.units;
    var diffColor = Colors.black;
    if (diff < 0) {
      diffColor = Colors.red;
    } else if (diff > 0) {
      diffColor = Colors.green;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FlexiblePriceCell(
            text: '${(diff).abs().toStringAsFixed(4)}',
            color: diffColor,
          ),
          FlexiblePriceCell(
            text: '${position.price.toStringAsFixed(4)}',
          ),
        ],
      ),
    );
  }
}

class FlexiblePriceCell extends StatelessWidget {
  FlexiblePriceCell({this.color = Colors.black, @required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w300,
          color: color,
        ),
      ),
    );
  }
}
