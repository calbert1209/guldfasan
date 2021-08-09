import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef void OnChangedHandler(DateTime datetime);

class DateTimeFormField extends StatelessWidget {
  DateTimeFormField({
    Key? key,
    required this.isActive,
    required this.dateTime,
    required this.onChanged,
    required this.onCancelled,
    required this.onTapped,
  }) : super(key: key);

  final bool isActive;
  final DateTime dateTime;
  final OnChangedHandler onChanged;
  final VoidCallback onCancelled;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.today,
              color: isActive ? Colors.amber : Colors.grey.shade600,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'date / time',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  DateFormat("yyyy-MM-dd HH:mm").format(dateTime),
                  style: TextStyle(
                    fontFamily: 'KoHo',
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                    color: Colors.brown.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () async {
        onTapped();

        var nextDate = await showDatePicker(
          context: context,
          initialDate: dateTime,
          firstDate: DateUtils.addMonthsToMonthDate(dateTime, -12),
          lastDate: DateUtils.addMonthsToMonthDate(dateTime, 12),
        );

        if (nextDate == null) {
          onCancelled();
          return;
        }

        var originalTime =
            TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
        var nextTime =
            await showTimePicker(context: context, initialTime: originalTime);

        var nextDateTime = DateTime(
          nextDate.year,
          nextDate.month,
          nextDate.day,
          nextTime?.hour ?? nextDate.hour,
          nextTime?.minute ?? nextDate.minute,
        );

        onChanged(nextDateTime);
      },
    );
  }
}
