import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/components/details_list_view.dart';
import 'package:lichee/components/details_rows.dart';

void main() {
  group('test details list view', () {
    testWidgets('create list view for non-member user', (tester) async {
      final channel = ReadChannelDto(
        channelId: 'channelId',
        channelName: 'channelName',
        ownerId: 'ownerId',
        channelImageURL: 'channelImageURL',
        createdOn: DateTime.now(),
        city: 'city',
        isPromoted: false,
        userIds: ['userId'],
        description: 'hello',
      );
      final description = DetailsRows(channel: channel, isAboutTable: false);
      final about = DetailsRows(channel: channel, isAboutTable: true);
      final widget = DetailsListView(
          channel: channel,
          description: description,
          about: about,
          isMember: false);
      final screen = MaterialApp(home: Scaffold(body: widget));
      await tester.pumpWidget(screen);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('create list view for member user', (tester) async {
      final channel = ReadChannelDto(
        channelId: 'channelId',
        channelName: 'channelName',
        ownerId: 'ownerId',
        channelImageURL: 'channelImageURL',
        createdOn: DateTime.now(),
        city: 'city',
        isPromoted: false,
        userIds: ['userId'],
        description: 'hello',
      );
      final description = DetailsRows(channel: channel, isAboutTable: false);
      final about = DetailsRows(channel: channel, isAboutTable: true);
      final widget = DetailsListView(
          channel: channel,
          description: description,
          about: about,
          isMember: true);
      final screen = MaterialApp(home: Scaffold(body: widget));
      await tester.pumpWidget(screen);
      expect(find.text('Members'), findsOneWidget);
    });
  });
}
