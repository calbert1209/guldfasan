import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/bottom_nav_bar.dart';
import 'package:guldfasan/widgets/currency_dropdown.dart';
import 'package:guldfasan/widgets/date_time_form_field.dart';
import 'package:guldfasan/widgets/numeric_form_field.dart';
import 'package:guldfasan/widgets/sub_page_scaffold.dart';

typedef void OnUpdatedHandler(Position position);

class EditPositionSubPage extends StatefulWidget {
  const EditPositionSubPage({
    Key? key,
    this.position,
    required this.onUpdatedHandler,
    required this.title,
  }) : super(key: key);

  final Position? position;
  final OnUpdatedHandler onUpdatedHandler;
  final String title;

  @override
  EditPositionFormState createState() => EditPositionFormState(position);
}

class EditPositionFormState extends State<EditPositionSubPage> {
  EditPositionFormState(Position? position)
      : _symbol = position?.symbol ?? 'BTC',
        _unitsController =
            TextEditingController(text: position?.units.toString() ?? ''),
        _priceController =
            TextEditingController(text: position?.price.toString() ?? ''),
        _dateTime = position?.dateTime ?? DateTime.now();

  String _symbol;
  final _unitsController;
  final _priceController;
  DateTime _dateTime;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
        title: widget.title,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DateTimeFormField(
                    dateTime: _dateTime,
                    onChange: (nextDateTime) => setState(() {
                      _dateTime = nextDateTime;
                    }),
                  ),
                  CurrencyDropdown(
                    value: _symbol,
                    onChanged: (nextValue) {
                      if (nextValue != null) {
                        setState(() {
                          _symbol = nextValue;
                        });
                      }
                    },
                  ),
                  NumericFormField(
                    controller: _unitsController,
                    labelText: "units",
                    icon: Icons.toll,
                  ),
                  NumericFormField(
                    controller: _priceController,
                    labelText: 'unit price',
                    icon: Icons.sell,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          unselectedItemColor: Colors.brown.shade400,
          onBack: () => Navigator.pop(context),
          items: [
            NavBarItem(
              icon: Icons.check,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  var added = Position(
                    id: widget.position?.id,
                    dateTime: _dateTime,
                    symbol: _symbol,
                    units: double.parse(_unitsController.text),
                    price: double.parse(_priceController.text),
                  );

                  widget.onUpdatedHandler(added);
                }
              },
            ),
          ],
        ));
  }
}
