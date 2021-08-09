import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:intl/intl.dart';

typedef void OnUpdatedHandler(Position position);

class EditPositionForm extends StatefulWidget {
  const EditPositionForm({
    Key? key,
    this.position,
    required this.onUpdatedHandler,
  }) : super(key: key);

  final Position? position;
  final OnUpdatedHandler onUpdatedHandler;

  @override
  EditPositionFormState createState() => EditPositionFormState(position);
}

class EditPositionFormState extends State<EditPositionForm> {
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.today,
                    color: _dateSelectorActive
                        ? Colors.amber
                        : Colors.grey.shade600,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                      child: Text(
                        'date / time',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.w500,
                          fontSize: 24.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        DateFormat("yyyy-MM-dd HH:mm").format(_dateTime),
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.w500,
                          fontSize: 32.0,
                          color: Colors.brown.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () async {
              setState(() {
                _dateSelectorActive = true;
              });
              var nextDate = await showDatePicker(
                context: context,
                initialDate: _dateTime,
                firstDate: DateUtils.addMonthsToMonthDate(_dateTime, -12),
                lastDate: DateUtils.addMonthsToMonthDate(_dateTime, 12),
              );

              if (nextDate == null) {
                setState(() {
                  _dateSelectorActive = false;
                });
                return;
              }
              var originalTime =
                  TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute);
              var nextTime = await showTimePicker(
                  context: context, initialTime: originalTime);

              var nextDateTime = DateTime(
                nextDate.year,
                nextDate.month,
                nextDate.day,
                nextTime?.hour ?? nextDate.hour,
                nextTime?.minute ?? nextDate.minute,
              );
              setState(() {
                _dateTime = nextDateTime;
                _dateSelectorActive = false;
              });
            },
          ),
          DropdownButtonFormField(
            style: TextStyle(
              fontFamily: 'Rajdhani',
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
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.w500,
                    fontSize: 32.0,
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
                fontSize: 32.0,
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
                fontSize: 32.0,
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
                fontSize: 32.0,
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
          ElevatedButton(
            onPressed: () {
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
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
