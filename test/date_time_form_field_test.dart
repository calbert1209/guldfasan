import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guldfasan/widgets/date_time_form_field.dart';

void main() {
  group('DateTimeFormField', () {
    testWidgets('formats and displays historical date/time correctly',
        (WidgetTester tester) async {
      final initialDate = DateTime(2013, 5, 10, 14, 30);
      DateTime? changedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateTimeFormField(
              dateTime: initialDate,
              onChange: (dt) => changedDate = dt,
            ),
          ),
        ),
      );

      // Verify date and time formatted string is shown
      expect(find.text('2013-05-10 14:30'), findsOneWidget);
      expect(find.text('date / time'), findsOneWidget);
      expect(changedDate, isNull);
    });

    testWidgets('allows picking historical dates earlier than 2020',
        (WidgetTester tester) async {
      // Start with a historical date from 2015
      final initialDate = DateTime(2015, 6, 15, 10, 0);
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateTimeFormField(
              dateTime: initialDate,
              onChange: (dt) => selectedDate = dt,
            ),
          ),
        ),
      );

      // Tap on the form field to trigger showDatePicker
      await tester.tap(find.byType(DateTimeFormField));
      await tester.pumpAndSettle();

      // Verify DatePickerDialog opened with historical year 2015
      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.textContaining('2015'), findsWidgets);

      // Tap OK on the date picker
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Time picker should now be open, tap OK on time picker
      expect(find.byType(TimePickerDialog), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(selectedDate, isNotNull);
      expect(selectedDate!.year, equals(2015));
      expect(selectedDate!.month, equals(6));
      expect(selectedDate!.day, equals(15));
    });

    testWidgets('safely clamps initialDate when dateTime is before firstDate',
        (WidgetTester tester) async {
      // Provide date earlier than firstDate
      final veryOldDate = DateTime(1950, 1, 1);
      final customFirstDate = DateTime(1970, 1, 1);
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateTimeFormField(
              dateTime: veryOldDate,
              firstDate: customFirstDate,
              onChange: (dt) => selectedDate = dt,
            ),
          ),
        ),
      );

      // Tap should not throw an assertion error despite initial date < firstDate
      await tester.tap(find.byType(DateTimeFormField));
      await tester.pumpAndSettle();

      // Date picker opens clamped to firstDate (1970)
      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.textContaining('1970'), findsWidgets);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(selectedDate, isNull);
    });
  });
}
