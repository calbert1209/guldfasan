import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/text_styles.dart';
import 'package:intl/intl.dart';

class DataViewText extends StatelessWidget {
  DataViewText(this.text, {Key? key, this.padding = EdgeInsets.zero})
      : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: KoHoMedium(
          color: Colors.brown.shade700,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class DataViewCard extends StatelessWidget {
  DataViewCard({Key? key, required this.position}) : super(key: key);

  final Position position;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataViewText(
              DateFormat("yyyy-MM-dd HH:mm").format(position.dateTime),
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
            ),
            Row(
              children: [
                DataViewText(position.units.toString()),
                DataViewText(
                  position.symbol,
                  padding: const EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                ),
                DataViewText('@'),
                DataViewText(
                  position.price.toString(),
                  padding: const EdgeInsets.only(left: 5.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
