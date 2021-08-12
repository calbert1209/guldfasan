import 'package:flutter/material.dart';
import 'package:guldfasan/widgets/text_styles.dart';

typedef void DropdownOnChangeHandler(String? nextValue);

class CurrencyDropdown extends StatelessWidget {
  CurrencyDropdown({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final String value;
  final DropdownOnChangeHandler onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      iconEnabledColor: Colors.brown.shade400,
      style: KoHoMedium(
        fontSize: 32.0,
        color: Colors.brown.shade700,
      ),
      value: value,
      onChanged: onChanged,
      items: ['BTC', 'ETH'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: KoHoMedium(
              fontSize: 30.0,
              color: Colors.brown.shade700,
            ),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        icon: Icon(
          Icons.paid,
          color: Colors.brown.shade400,
        ),
        labelText: 'currency',
        labelStyle: RajdhaniMedium(
          fontSize: 28.0,
          color: Colors.brown.shade400,
        ),
      ),
    );
  }
}
