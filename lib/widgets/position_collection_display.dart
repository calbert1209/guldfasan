import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';

class PositionCollectionDisplay extends StatelessWidget {
  PositionCollectionDisplay(
      {required this.collection, required this.currentPrice});

  final PositionCollection collection;
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
              Text(
                collection.symbol,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
        ...this.collection.positions.map((Position position) {
          return PositionDisplay(
            position: position,
            currentPrice: currentPrice,
          );
        }).toList(),
      ],
    );
  }
}

class PositionDisplay extends StatelessWidget {
  PositionDisplay(
      {Key? key, required this.position, required this.currentPrice});

  final Position position;
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
            text: '${position.price.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }
}

class FlexiblePriceCell extends StatelessWidget {
  FlexiblePriceCell({this.color = Colors.black, required this.text});

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
          fontFamily: 'KoHo',
          fontWeight: FontWeight.w300,
          fontSize: 24.0,
          letterSpacing: -0.6,
          color: color,
        ),
      ),
    );
  }
}
