import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:intl/intl.dart';

class PositionDetailsPage extends StatelessWidget {
  PositionDetailsPage({required this.position, required this.currentPrice});

  final Position position;
  final double currentPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.amber.shade700,
          ),
          onPressed: () => Navigator.pop(
            context,
            this.position,
          ),
        ),
        title: Text(
          "Position Details",
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: Colors.amber.shade700,
          ),
        ),
      ),
      body: Column(
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

  final currencyFormatter = NumberFormat.simpleCurrency(
    locale: "en-US",
    name: "JPY",
    decimalDigits: 3,
  );

  @override
  Widget build(BuildContext context) {
    final valueAtPurchase = position.units * position.price;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            currencyFormatter.format(valueAtPurchase),
            style: TextStyle(
              fontFamily: 'KoHo',
              fontWeight: FontWeight.w500,
              fontSize: 40.0,
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

  final currencyFormatter = NumberFormat.simpleCurrency(
    locale: "en-US",
    name: "JPY",
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ' ( ',
        position.units.toString(),
        ' ${position.symbol}',
        ' @ ',
        currencyFormatter.format(position.price),
        ' ) ',
      ].map<Widget>((it) {
        return Text(
          it,
          style: TextStyle(
            fontFamily: 'KoHo',
            fontWeight: FontWeight.w300,
            fontSize: 20.0,
            color: Colors.grey,
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
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
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
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    final dateString = dateFormat.format(dateTime);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dateString,
            style: TextStyle(
              fontFamily: "KoHo",
              fontSize: 32.0,
              color: Colors.grey,
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

  final currencyFormatter = NumberFormat.simpleCurrency(
    locale: "en-US",
    name: "JPY",
    decimalDigits: 3,
  );
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
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: padding,
          child: Text(
            currencyFormatter.format(totalProfit),
            style: TextStyle(
              fontFamily: family,
              fontSize: size,
              fontWeight: FontWeight.w500,
              color: totalProfit > 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[],
        ),
      ),
    );
  }
}
