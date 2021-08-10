import 'package:flutter/material.dart';

var _retry = {
  50: Colors.amber.shade50,
  100: Colors.amber.shade100,
  200: Colors.amber.shade200,
  300: Colors.amber.shade300,
  400: Colors.amber.shade400,
  500: Colors.amber.shade500,
  600: Colors.amber.shade600,
  700: Colors.amber.shade700,
  800: Colors.amber.shade800,
  900: Colors.amber.shade900,
};

/// Creates a custom MaterialColor based on `Colors.amber`, with the primary color
/// set to `amber.shade700`
MaterialColor customAmber() {
  return MaterialColor(Colors.amber.shade700.value, _retry);
}
