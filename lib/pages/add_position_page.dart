import 'package:flutter/material.dart';
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
  String dropdownValue = 'BTC';
  DateTime dateTime = DateTime.now();
  final _dateController =
      TextEditingController(text: DateTime.now().toIso8601String());

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.

          TextFormField(
            decoration: InputDecoration(
                icon: Icon(Icons.today), labelText: 'date / time'),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: _dateController,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: DateUtils.addMonthsToMonthDate(dateTime, -12),
                lastDate: DateUtils.addMonthsToMonthDate(dateTime, 12),
              ).then((nextDateTime) {
                setState(() {
                  _dateController.text = nextDateTime!.toIso8601String();
                });
              });
            },
          ),
          DropdownButtonFormField(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
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
