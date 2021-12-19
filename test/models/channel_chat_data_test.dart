import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/channel_chat_data.dart';

void main() {
  group('ChannelChatData', () {
    test('copyWith method works fine', () {
      final original = ChannelChatData(
        channelId: 'channelId',
        channelName: 'channelName',
        photoUrl: 'photoUrl',
        userIds: List.empty(),
      );

      final copiedWith = original.copyWith(
        channelId: 'new channelId',
        recentMessageSentAt: DateTime(2000),
        recentMessageSentBy: 'new recentMessageSentBy',
        recentMessageText: 'new recentMessageText',
      );

      expect('channelId', equals(original.channelId));
      expect('channelName', equals(original.channelName));
      expect('photoUrl', equals(original.photoUrl));
      expect(List.empty(), equals(original.userIds));
      expect(null, equals(original.recentMessageSentAt));
      expect(null, equals(original.recentMessageSentBy));
      expect(null, equals(original.recentMessageText));

      expect('new channelId', equals(copiedWith.channelId));
      expect('channelName', equals(copiedWith.channelName));
      expect('photoUrl', equals(copiedWith.photoUrl));
      expect(List.empty(), equals(copiedWith.userIds));
      expect(DateTime(2000), equals(copiedWith.recentMessageSentAt));
      expect('new recentMessageSentBy', equals(copiedWith.recentMessageSentBy));
      expect('new recentMessageText', equals(copiedWith.recentMessageText));
    });

    test('mapToChannelChatData methods works fine', () {
      final map = {
        'channelId': 'channelId',
        'channelName': 'channelName',
        'photoUrl': 'photoUrl',
        'userIds': List.empty(),
        'recentMessageSentAt': Timestamp.fromDate(DateTime(2000)),
        'recentMessageSentBy': 'recentMessageSentBy',
        'recentMessageText': 'recentMessageText'
      };

      final channelChatData = ChannelChatData.mapToChannelChatData(map);

      expect('channelId', equals(channelChatData.channelId));
      expect('channelName', equals(channelChatData.channelName));
      expect('photoUrl', equals(channelChatData.photoUrl));
      expect(List.empty(), equals(channelChatData.userIds));
      expect(DateTime(2000), equals(channelChatData.recentMessageSentAt));
      expect(
        'recentMessageSentBy',
        equals(channelChatData.recentMessageSentBy),
      );
      expect('recentMessageText', equals(channelChatData.recentMessageText));
    });

    test('toMap method works fine', () {
      final channelChatData = ChannelChatData(
        channelId: 'channelId',
        channelName: 'channelName',
        photoUrl: 'photoUrl',
        userIds: List.of(['userId']),
      );

      final map = channelChatData.toMap();

      expect('channelId', equals(map['channelId']));
      expect('channelName', equals(map['channelName']));
      expect('photoUrl', equals(map['photoUrl']));
      expect(1, equals(List.from(map['userIds']).length));
      expect('userId', equals(List.from(map['userIds'])[0]));
      expect(null, equals(channelChatData.recentMessageSentAt));
      expect(null, equals(channelChatData.recentMessageSentBy));
      expect(null, equals(channelChatData.recentMessageText));
    });

    group('compareTo method', () {
      test('works fine when both are not null and are equal', () {
        final channelChatData1 = ChannelChatData(
            channelId: 'channelId',
            channelName: 'channelName',
            photoUrl: 'photoUrl',
            userIds: List.of(['userId']),
            recentMessageSentAt: DateTime(2020, 2, 3)
        );

        final channelChatData2 = ChannelChatData(
            channelId: 'channelId',
            channelName: 'channelName',
            photoUrl: 'photoUrl',
            userIds: List.of(['userId']),
            recentMessageSentAt: DateTime(2000, 2, 3)
        );

        expect(1, equals(channelChatData1.compareTo(channelChatData2)));
      });

      test('works fine when both are not null and are different', () {
        final channelChatData1 = ChannelChatData(
          channelId: 'channelId',
          channelName: 'channelName',
          photoUrl: 'photoUrl',
          userIds: List.of(['userId']),
          recentMessageSentAt: DateTime(2020)
        );

        final channelChatData2 = ChannelChatData(
          channelId: 'channelId',
          channelName: 'channelName',
          photoUrl: 'photoUrl',
          userIds: List.of(['userId']),
          recentMessageSentAt: DateTime(2000)
        );

        expect(1, equals(channelChatData1.compareTo(channelChatData2)));
      });

      test('works fine when any of them is null', () {
        final channelChatData1 = ChannelChatData(
          channelId: 'channelId',
          channelName: 'channelName',
          photoUrl: 'photoUrl',
          userIds: List.of(['userId']),
        );

        final channelChatData2 = ChannelChatData(
          channelId: 'channelId',
          channelName: 'channelName',
          photoUrl: 'photoUrl',
          userIds: List.of(['userId']),
        );

        expect(0, equals(channelChatData1.compareTo(channelChatData2)));
      });
    });
  });
}
