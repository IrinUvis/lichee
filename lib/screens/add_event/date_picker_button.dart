import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/constants/icons.dart';
import 'event_date.dart';

class DatePickerButton extends StatefulWidget {
  final EventDate eventDate;

  const DatePickerButton({Key? key, required this.eventDate}) : super(key: key);

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  Widget getDateText() {
    if (widget.eventDate.date == null) {
      return kSelectDateButtonContent;
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat('dd/MM/yyyy').format(widget.eventDate.date!),
              style: const TextStyle(color: Colors.white, fontSize: 20.0),),
          const SizedBox(width: 10.0),
          kDateIcon
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => pickDate(context),
        child: getDateText(),
        style: kGreyRoundedButtonStyle,
      );

  Future pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: widget.eventDate.date ?? initialDate,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    setState(() => widget.eventDate.date = newDate);
  }
}
