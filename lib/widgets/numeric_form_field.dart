import 'package:flutter/material.dart';
import 'package:guldfasan/widgets/text_styles.dart';

class NumericFormField extends StatelessWidget {
  NumericFormField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.guidance = "Please enter numeric value",
  });

  final TextEditingController controller;
  final String guidance;
  final String labelText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: KoHoMedium(
        fontSize: 32.0,
        color: Colors.brown.shade700,
      ),
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.brown.shade400,
        ),
        labelText: labelText,
        labelStyle: RajdhaniMedium(
          fontSize: 28.0,
          color: Colors.brown.shade400,
        ),
      ),
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return guidance;
        }
        return null;
      },
    );
  }
}
