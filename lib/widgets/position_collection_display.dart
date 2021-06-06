import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    final dateFormat = DateFormat.yMd('en_us').add_Hm();
    final dateString = dateFormat.format(position.dateTime);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Column(
        children: [
          Row(
            children: [
              FlexiblePriceCell(
                text: dateString,
                textAlign: TextAlign.left,
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlexiblePriceCell(
                text: '${(diff).abs().toStringAsFixed(4)}',
                color: diffColor,
              ),
              FlexiblePriceCell(
                text: '${position.price.toStringAsFixed(0)}',
              ),
              FlexiblePriceCell(
                text: '${currentPrice.toStringAsFixed(0)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FlexiblePriceCell extends StatelessWidget {
  FlexiblePriceCell({
    required this.text,
    this.color = Colors.black,
    this.textAlign = TextAlign.right,
    this.fontSize = 24.0,
  });

  final Color color;
  final String text;
  final TextAlign textAlign;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: 'KoHo',
          fontWeight: FontWeight.w300,
          fontSize: fontSize,
          letterSpacing: -0.6,
          color: color,
        ),
      ),
    );
  }
}
