import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/pages/postion_details_page.dart';
import 'package:intl/intl.dart';

const _positionCollectionInsets = EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0);
final String Function(dynamic number) _formatCurrency =
    NumberFormat.simpleCurrency(
  locale: "en-US",
  name: "JPY",
).format;

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
    return Container(
      padding: _positionCollectionInsets,
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
            _formatCurrency(currentPrice),
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
  final dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final diff = (currentPrice - position.price) * position.units;
    var diffColor = Colors.black;
    if (diff < 0) {
      diffColor = Colors.red.shade700;
    } else if (diff > 0) {
      diffColor = Colors.lightGreen.shade700;
    }
    final dateString = dateFormatter.format(position.dateTime);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            2.0,
          ),
        ),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          Navigator.push<Position>(
            context,
            MaterialPageRoute(
              builder: (context) => PositionDetailsPage(
                position: position,
                currentPrice: currentPrice,
              ),
            ),
          ).then((data) => print(data?.toMap().toString()));
        },
        child: Padding(
          padding: _positionCollectionInsets,
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
                    text: '${_formatCurrency(diff)}',
                    color: diffColor,
                  ),
                ],
              ),
            ],
          ),
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
    this.padding = EdgeInsets.zero,
    this.family = "KoHo",
    this.weight = FontWeight.w300,
  });

  final Color color;
  final String text;
  final TextAlign textAlign;
  final double fontSize;
  final EdgeInsets padding;
  final String family;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: 'KoHo',
            fontWeight: weight,
            fontSize: fontSize,
            letterSpacing: -0.6,
            color: color,
          ),
        ),
      ),
    );
  }
}
