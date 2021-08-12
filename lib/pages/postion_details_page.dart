import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/models/position_operation.dart';
import 'package:guldfasan/pages/edit_position_page.dart';
import 'package:guldfasan/widgets/bottom_nav_bar.dart';
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
      // onCompleted: () => Navigator.pop(
      //   context,
      //   PositionOperation(
      //     position: position,
      //     type: OperationType.none,
      //   ),
      // ),
      title: "Position Details",
      titleFontSize: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DetailsHeader(position: position, currentPrice: currentPrice),
          SectionLabel(text: 'Current Value'),
          PurchaseValue(
            position: position,
            currentPrice: currentPrice,
          ),
          PurchaseValueBreakDown(
            position: position,
            currentPrice: currentPrice,
          ),
          SectionLabel(text: 'Value at Purchase'),
          PurchaseValue(position: position),
          PurchaseValueBreakDown(position: position),
          SectionLabel(text: 'Purchase Date'),
          PurchaseDateLabel(dateTime: position.dateTime),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(
            context,
            PositionOperation(
              position: position,
              type: OperationType.delete,
            ),
          ),
          icon: Icon(
            Icons.delete,
            color: Colors.grey.shade700,
          ),
        )
      ],
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onBack: () => Navigator.pop(
          context,
          PositionOperation(
            position: position,
            type: OperationType.update,
          ),
        ),
        items: [
          NavBarItem(
            icon: Icons.edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<PositionOperation>(
                  builder: (context) => EditPositionPage(position: position),
                ),
              ).then((result) {
                if (result != null && result.type == OperationType.update) {
                  Navigator.pop(context, result);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class PurchaseValue extends StatelessWidget {
  PurchaseValue({
    Key? key,
    required this.position,
    this.currentPrice,
  }) : super(key: key);

  final Position position;
  final double? currentPrice;

  @override
  Widget build(BuildContext context) {
    final price = currentPrice ?? position.price;
    final valueAtPurchase = position.units * price;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
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
    this.currentPrice,
  }) : super(key: key);

  final Position position;
  final double? currentPrice;

  final String Function(dynamic number) _formatCurrency =
      NumberFormat.simpleCurrency(
    locale: "en-US",
    name: "JPY",
  ).format;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ' ( ',
          position.units.toString(),
          ' ${position.symbol}',
          ' @ ',
          _formatCurrency(currentPrice ?? position.price),
          // ' ) ',
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
      ),
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
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24.0),
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
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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
