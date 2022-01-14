import 'package:flutter/material.dart';

class EventDate {
  DateTime? date;
  TimeOfDay? time;

  EventDate() {
    date = null;
    time = null;
  }

  DateTime getCombinedDate() {
    return DateTime(
        date!.year, date!.month, date!.day, time!.hour, time!.minute);
  }

  bool validate() {
    if (date == null || time == null) {
      return false;
    } else {
      return true;
    }
  }
}
