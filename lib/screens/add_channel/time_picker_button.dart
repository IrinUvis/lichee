import 'package:flutter/material.dart';

import 'event_date.dart';

class TimePickerButton extends StatefulWidget {
  final EventDate eventDate;

  const TimePickerButton({Key? key, required this.eventDate}) : super(key: key);

  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  Text getTimeText() {
    if (widget.eventDate.time == null) {
      return const Text('Select Time');
    } else {
      final hours = widget.eventDate.time!.hour.toString().padLeft(2, '0');
      final minutes = widget.eventDate.time!.minute.toString().padLeft(2, '0');

      return Text('$hours:$minutes');
    }
  }

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(onPressed: () => pickTime(context), child: getTimeText());

  Future pickTime(BuildContext context) async {
    const initialTime = TimeOfDay(hour: 8, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: widget.eventDate.time ?? initialTime,
    );
    setState(() => widget.eventDate.time = newTime);
  }
}
