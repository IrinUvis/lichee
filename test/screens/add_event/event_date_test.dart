import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/screens/add_event/event_date.dart';

void main() {
  late EventDate eventDate;

  setUp(() {
    eventDate = EventDate();
    eventDate.date = DateTime(2000, 1, 1);
    eventDate.time = const TimeOfDay(hour: 10, minute: 30);
  });

  test('Test getCombinedDate', () {
    expect(eventDate.getCombinedDate(), DateTime(2000, 1, 1, 10, 30));
  });

  test('Test validate', () {
    expect(eventDate.validate(), true);
    eventDate.time = null;
    expect(eventDate.validate(), false);
    eventDate.date = null;
    expect(eventDate.validate(), false);
    eventDate.time = const TimeOfDay(hour: 10, minute: 30);
    expect(eventDate.validate(), false);
    eventDate.date = DateTime(2000, 1, 1);
    expect(eventDate.validate(), true);
  });

  test('Test clear', () {
    expect(eventDate.validate(), true);
    eventDate.clear();
    expect(eventDate.validate(), false);
    expect(eventDate.date, null);
    expect(eventDate.time, null);
  });
}