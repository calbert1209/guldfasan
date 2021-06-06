import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:intl/intl.dart';

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
        Header(
          symbol: collection.symbol,
          currentPrice: currentPrice,
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

class Header extends StatelessWidget {
  Header({required this.symbol, required this.currentPrice});

  final String symbol;
  final double currentPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            symbol,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
          Text(
            currentPrice.toStringAsFixed(0),
            style: TextStyle(
              fontFamily: 'KoBo',
              fontWeight: FontWeight.w300,
              fontSize: 32,
            ),
          ),
        ],
      ),
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
    final dateFormat = DateFormat.yMd('en_us');
    final dateString = dateFormat.format(position.dateTime);
    return InkWell(
      onTap: () {
        print(position.toMap().toString());
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FlexiblePriceCell(
                  text: dateString,
                  textAlign: TextAlign.left,
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
                FlexiblePriceCell(
                  text: '${(diff).abs().toStringAsFixed(4)}',
                  color: diffColor,
                ),
              ],
            ),
          ],
        ),
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
