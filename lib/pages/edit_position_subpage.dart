import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/bottom_nav_bar.dart';
import 'package:guldfasan/widgets/date_time_form_field.dart';
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
  bool _dateSelectorActive = false;

  final String _valueGuidance = "Please enter numeric value";

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
                    isActive: _dateSelectorActive,
                    onCancelled: () => setState(() {
                      _dateSelectorActive = false;
                    }),
                    onChanged: (nextDateTime) => setState(() {
                      _dateTime = nextDateTime;
                      _dateSelectorActive = false;
                    }),
                    onTapped: () => setState(
                      () {
                        _dateSelectorActive = true;
                      },
                    ),
                  ),
                  DropdownButtonFormField(
                    style: TextStyle(
                      fontFamily: 'KoHo',
                      fontWeight: FontWeight.w500,
                      fontSize: 32.0,
                      color: Colors.brown.shade700,
                    ),
                    value: _symbol,
                    onChanged: (String? newValue) {
                      setState(() {
                        _symbol = newValue!;
                      });
                    },
                    items: <String>['BTC', 'ETH']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'KoHo',
                            fontWeight: FontWeight.w500,
                            fontSize: 30.0,
                            color: Colors.brown.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.paid,
                      ),
                      labelText: 'currency',
                      labelStyle: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.w500,
                        fontSize: 28.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontFamily: 'KoHo',
                      fontWeight: FontWeight.w500,
                      fontSize: 32.0,
                      color: Colors.brown.shade700,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.toll,
                      ),
                      labelText: 'units',
                      labelStyle: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.w500,
                        fontSize: 28.0,
                        color: Colors.grey,
                      ),
                    ),
                    controller: _unitsController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _valueGuidance;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontFamily: 'KoHo',
                      fontWeight: FontWeight.w500,
                      fontSize: 32.0,
                      color: Colors.brown.shade700,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.sell,
                      ),
                      labelText: 'unit price',
                      labelStyle: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.w500,
                        fontSize: 28.0,
                        color: Colors.grey,
                      ),
                    ),
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _valueGuidance;
                      }
                      print(value.runtimeType);
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
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
