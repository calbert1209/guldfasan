import 'package:flutter/material.dart';

class KoHoMedium extends TextStyle {
  KoHoMedium({
    required double fontSize,
    required Color color,
  }) : super(
          fontFamily: 'KoHo',
          fontWeight: FontWeight.w500,
          color: color,
          fontSize: fontSize,
        );
}

class RajdhaniMedium extends TextStyle {
  RajdhaniMedium({
    required double fontSize,
    required Color color,
  }) : super(
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.w500,
          color: color,
          fontSize: fontSize,
        );
}

class RajdhaniBold extends TextStyle {
  RajdhaniBold({
    required double fontSize,
    required Color color,
  }) : super(
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.w700,
          color: color,
          fontSize: fontSize,
        );
}
