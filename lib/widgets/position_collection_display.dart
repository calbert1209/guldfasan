import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/cash_flow.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/models/position_operation.dart';
import 'package:guldfasan/pages/postion_details_page.dart';
import 'package:guldfasan/widgets/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'flexible_price_cell.dart';

const PositionCollectionInsets = EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0);
final String Function(dynamic number) _formatCurrency =
    NumberFormat.simpleCurrency(
  locale: "en-US",
  name: "JPY",
).format;

Color colorForSign(num value) {
  if (value < 0) {
    return Colors.red.shade900;
  } else if (value > 0) {
    return Colors.green.shade300;
  } else {
    return Colors.brown.shade700;
  }
}

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
        _Header(
          symbol: collection.symbol,
          currentPrice: currentPrice,
          collection: collection,
        ),
        ...this.collection.positions.map((Position position) {
          return _PositionDisplay(
            position: position,
            currentPrice: currentPrice,
          );
        }).toList(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  _Header({
    required this.symbol,
    required currentPrice,
    required collection,
  })  : this.currentPrice = currentPrice,
        this.cashFlow = tallyCollectionCashFlow(collection, currentPrice);

  final String symbol;
  final double currentPrice;
  final CashFlow cashFlow;
  final _color = Colors.brown.shade700;

  @override
  Widget build(BuildContext context) {
    final rateOfReturn = cashFlow.rateOfReturn();
    final rateOfReturnColor = colorForSign(rateOfReturn * 100);
    final percentReturn = (rateOfReturn * 100).toStringAsFixed(2);

    return Container(
      padding: PositionCollectionInsets,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            symbol,
            style: RajdhaniBold(
              fontSize: 32,
              color: _color,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  '${(percentReturn)}%',
                  style: TextStyle(
                    fontFamily: 'KoHo',
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: rateOfReturnColor,
                  ),
                ),
              ),
              Text(
                _formatCurrency(currentPrice),
                style: TextStyle(
                  fontFamily: 'KoHo',
                  fontWeight: FontWeight.w300,
                  fontSize: 28,
                  color: _color,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _PositionDisplay extends StatelessWidget {
  _PositionDisplay({
    Key? key,
    required this.position,
    required this.currentPrice,
  })  : diff = (currentPrice - position.price) * position.units,
        super(key: key);

  final Position position;
  final double currentPrice;
  final double diff;
  final _formatDate = DateFormat('yyyy-MM-dd').format;

  @override
  Widget build(BuildContext context) {
    var diffColor = colorForSign(diff);
    var appState = Provider.of<AppState>(context);
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
          Navigator.push<PositionOperation>(
            context,
            MaterialPageRoute(
              builder: (context) => PositionDetailsPage(
                position: position,
                currentPrice: currentPrice,
              ),
            ),
          ).then((data) {
            if (data == null) return;

            if (data.type == OperationType.update) {
              appState.updatePosition(data.position);
            } else if (data.type == OperationType.delete) {
              var id = data.position.id;
              if (id != null) {
                appState.deletePosition(id);
              }
            }
          });
        },
        child: Padding(
          padding: PositionCollectionInsets,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlexiblePriceCell(
                    text: _formatDate(position.dateTime),
                    textAlign: TextAlign.left,
                    fontSize: 20.0,
                    color: Colors.brown.shade300,
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
