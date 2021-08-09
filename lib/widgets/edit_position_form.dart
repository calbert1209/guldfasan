import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';

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
        _dateTime = position?.dateTime ?? DateTime.now(),
        _dateController = TextEditingController(
          text: position?.dateTime.toIso8601String() ??
              DateTime.now().toIso8601String(),
        );

  String _symbol;
  final _unitsController;
  final _priceController;
  final _dateController;
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
          // Add TextFormFields and ElevatedButton here.
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
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(_dateController.text),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _dateSelectorActive = true;
              });
              showDatePicker(
                context: context,
                initialDate: _dateTime,
                firstDate: DateUtils.addMonthsToMonthDate(_dateTime, -12),
                lastDate: DateUtils.addMonthsToMonthDate(_dateTime, 12),
              ).then((nextDateTime) {
                setState(() {
                  _dateController.text = nextDateTime!.toIso8601String();
                });
              }).whenComplete(() {
                setState(() {
                  _dateSelectorActive = false;
                });
              });
            },
          ),
          DropdownButtonFormField(
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
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.paid,
                ),
                labelText: 'currency'),
          ),
          TextFormField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.toll,
                ),
                labelText: 'units'),
            // The validator receives the text that the user has entered.
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
            decoration: InputDecoration(
                icon: Icon(
                  Icons.sell,
                ),
                labelText: 'unit price'),
            // The validator receives the text that the user has entered.
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
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Processing Data')),
                // );
                // show progress
                // await persistance
                // then pop
                var added = Position(
                  id: widget.position?.id,
                  dateTime: DateTime.parse(_dateController.text),
                  symbol: _symbol,
                  units: double.parse(_unitsController.text),
                  price: double.parse(_priceController.text),
                );
                widget.onUpdatedHandler(added);
                // Navigator.pop(
                //   context,
                //   PositionOperation(
                //     position: added,
                //     type: OperationType.create,
                //   ),
                // );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
