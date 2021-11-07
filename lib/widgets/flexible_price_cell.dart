import 'package:flutter/material.dart';

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
