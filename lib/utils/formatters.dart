import 'package:intl/intl.dart';

final String Function(dynamic number) formatPrice = NumberFormat.currency(
  locale: "en-US",
  symbol: "",
  decimalDigits: 0,
).format;

final String Function(dynamic number) formatDecimalPrice =
    NumberFormat.currency(
  locale: "en-US",
  symbol: "",
  decimalDigits: 3,
).format;
