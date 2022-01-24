import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/components/details_rows.dart';
import 'package:lichee/components/details_table.dart';

void main() {
  group('details table tests', () {
    final channelDTO = ReadChannelDto(
      channelId: 'testId',
      channelName: 'testDataName',
      ownerId: 'testOwner',
      channelImageURL: 'testURL',
      createdOn: DateTime.now(),
      city: 'testCity',
      isPromoted: false,
      userIds: ['testUser', 'testUser2'],
      description: 'noDescription',
    );
    testWidgets('test creation of details table', (tester) async {
      final rows = DetailsRows(channel: channelDTO, isAboutTable: false);
      final table = DetailsTable(rows: rows.create());
      final screen = MaterialApp(home: Scaffold(body: table));
      await tester.pumpWidget(screen);
      final found = find.text('testCity');
      expect(found, findsOneWidget);
    });

    testWidgets('test creation of rows of about', (tester) async {
      final rows = DetailsRows(channel: channelDTO, isAboutTable: true);
      final table = DetailsTable(rows: rows.create());
      final screen = MaterialApp(home: Scaffold(body: table));
      await tester.pumpWidget(screen);
      final found = find.text('2 members');
      expect(found, findsOneWidget);
    });
  });
}