import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guldfasan/models/position.dart';

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
              Text(
                collection.symbol,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
          style: GoogleFonts.koHo(
            textStyle: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
                color: color,
                letterSpacing: -0.6),
          ),
        ));
  }
}
