import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_date.dart';

class DatePickerButton extends StatefulWidget {
  final EventDate eventDate;

  const DatePickerButton({Key? key, required this.eventDate}) : super(key: key);

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  Text getDateText() {
    if (widget.eventDate.date == null) {
      return const Text('Select Date');
    } else {
      return Text(DateFormat('dd/MM/yyyy').format(widget.eventDate.date!));
    }
  }

  @override
  Widget build(BuildContext context) => ElevatedButton(onPressed: () => pickDate(context), child: getDateText());

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: widget.eventDate.date ?? initialDate,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    setState(() => widget.eventDate.date = newDate);
  }
}