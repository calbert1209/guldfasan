import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/models/position_operation.dart';
import 'package:guldfasan/widgets/sub_page_scaffold.dart';

class AddPositionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
      onCompleted: () => Navigator.pop(context),
      title: "Add Position",
      child: Column(
        children: [
          AddPositionForm(),
        ],
      ),
    );
  }
}

// Define a custom Form widget.
class AddPositionForm extends StatefulWidget {
  const AddPositionForm({Key? key}) : super(key: key);

  @override
  AddPositionFormState createState() {
    return AddPositionFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddPositionFormState extends State<AddPositionForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String _dropdownValue = 'BTC';
  DateTime dateTime = DateTime.now();
  final _dateController =
      TextEditingController(text: DateTime.now().toIso8601String());
  bool _dateSelectorActive = false;
  final _unitsController = TextEditingController();
  final _unitPriceController = TextEditingController();

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
                initialDate: dateTime,
                firstDate: DateUtils.addMonthsToMonthDate(dateTime, -12),
                lastDate: DateUtils.addMonthsToMonthDate(dateTime, 12),
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
            value: _dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue!;
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
            controller: _unitPriceController,
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
                  dateTime: DateTime.parse(_dateController.text),
                  symbol: _dropdownValue,
                  units: double.parse(_unitsController.text),
                  price: double.parse(_unitPriceController.text),
                );
                Navigator.pop(
                  context,
                  PositionOperation(
                    position: added,
                    type: OperationType.create,
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
