import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:guldfasan/widgets/sub_page_scaffold.dart';
import 'package:intl/intl.dart';

final String Function(dynamic number) _formatDecimalCurrency =
    NumberFormat.simpleCurrency(
  locale: "en-US",
  name: "JPY",
  decimalDigits: 3,
).format;

class PositionDetailsPage extends StatelessWidget {
  PositionDetailsPage({required this.position, required this.currentPrice});

  final Position position;
  final double currentPrice;

  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
      onCompleted: () => Navigator.pop(context, position),
      title: "Position Details",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DetailsHeader(position: position, currentPrice: currentPrice),
          SectionLabel(
            text: 'Purchase Date',
          ),
          PurchaseDateLabel(dateTime: position.dateTime),
          SectionLabel(
            text: 'Value at Purchase',
          ),
          PurchaseValue(position: position),
          PurchaseValueBreakDown(position: position)
        ],
      ),
    );
  }
}

class PurchaseValue extends StatelessWidget {
  PurchaseValue({
    Key? key,
    required this.position,
  }) : super(key: key);

  final Position position;

  @override
  Widget build(BuildContext context) {
    final valueAtPurchase = position.units * position.price;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            _formatDecimalCurrency(valueAtPurchase),
            style: TextStyle(
              fontFamily: 'KoHo',
              fontWeight: FontWeight.w500,
              fontSize: 40.0,
              color: Colors.brown.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

class PurchaseValueBreakDown extends StatelessWidget {
  PurchaseValueBreakDown({
    Key? key,
    required this.position,
  }) : super(key: key);

  final Position position;

  final String Function(dynamic number) _formatCurrency =
      NumberFormat.simpleCurrency(
    locale: "en-US",
    name: "JPY",
  ).format;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ' ( ',
        position.units.toString(),
        ' ${position.symbol}',
        ' @ ',
        _formatCurrency(position.price),
        ' ) ',
      ].map<Widget>((it) {
        return Text(
          it,
          style: TextStyle(
            fontFamily: 'KoHo',
            fontWeight: FontWeight.w300,
            fontSize: 20.0,
            color: Colors.brown.shade300,
          ),
        );
      }).toList(),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
              color: Colors.brown.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

class PurchaseDateLabel extends StatelessWidget {
  const PurchaseDateLabel({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat("yyyy-MM-dd HH:mm").format(dateTime);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dateString,
            style: TextStyle(
              fontFamily: "KoHo",
              fontSize: 32.0,
              color: Colors.brown.shade300,
            ),
          ),
        ),
      ],
    );
  }
}

class DetailsHeader extends StatelessWidget {
  DetailsHeader({
    Key? key,
    required this.position,
    required this.currentPrice,
  }) : super(key: key);

  final Position position;
  final double currentPrice;

  final String family = "KoHo";
  final double size = 32.0;
  final EdgeInsets padding = EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0);

  @override
  Widget build(BuildContext context) {
    final totalProfit = (currentPrice - position.price) * position.units;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: padding,
          child: Text(
            position.symbol,
            style: TextStyle(
              fontFamily: family,
              fontSize: size,
              fontWeight: FontWeight.w700,
              color: Colors.brown.shade700,
            ),
          ),
        ),
        Padding(
          padding: padding,
          child: Text(
            _formatDecimalCurrency(totalProfit),
            style: TextStyle(
              fontFamily: family,
              fontSize: size,
              fontWeight: FontWeight.w500,
              color: colorForSign(totalProfit),
            ),
          ),
        ),
      ],
    );
  }
}
