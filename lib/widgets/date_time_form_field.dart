import 'package:flutter/material.dart';
import 'package:guldfasan/widgets/text_styles.dart';
import 'package:intl/intl.dart';

typedef void OnChangedHandler(DateTime datetime);

class DateTimeFormField extends StatelessWidget {
  DateTimeFormField({
    Key? key,
    required this.dateTime,
    required this.onChange,
  }) : super(key: key);

  final DateTime dateTime;
  final OnChangedHandler onChange;

  Future<void> _onTap(BuildContext context) async {
    var nextDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateUtils.addMonthsToMonthDate(dateTime, -12),
      lastDate: DateUtils.addMonthsToMonthDate(dateTime, 12),
    );

    if (nextDate == null) {
      return;
    }

    var originalTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    var nextTime =
        await showTimePicker(context: context, initialTime: originalTime);

    if (nextTime == null) {
      return;
    }

    var nextDateTime = DateTime(
      nextDate.year,
      nextDate.month,
      nextDate.day,
      nextTime.hour,
      nextTime.minute,
    );

    onChange(nextDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.today,
              color: Colors.brown.shade400,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'date / time',
                  style: RajdhaniMedium(
                    fontSize: 22.0,
                    color: Colors.brown.shade400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  DateFormat("yyyy-MM-dd HH:mm").format(dateTime),
                  style: KoHoMedium(
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
        _onTap(context);
      },
    );
  }
}
