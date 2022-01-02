import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/channel_chat_data.dart';
import 'package:lichee/screens/chat_list/chat_list_card.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('ChatListCard', () {
    testWidgets('check in case of normal message', (tester) async {
      final chatListCardWidget = MaterialApp(
        home: Scaffold(
          body: ChatListCard(
            channelChatData: ChannelChatData(
              channelId: 'testChannelId',
              channelName: 'testChannelName',
              photoUrl: 'testPhotoUrl',
              recentMessageSentBy: 'testRecentMessageSentBy',
              recentMessageSentAt: DateTime(2021, 12, 30),
              recentMessageText: 'testRecentMessageText',
              userIds: ['testUserId'],
            ),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListCardWidget));

      expect(find.text('testRecentMessageSentBy: testRecentMessageText'),
          findsOneWidget);
      expect(find.text('testRecentMessageSentBy shared file'), findsNothing);
      expect(find.text('No messages present yet!'), findsNothing);
    });

    testWidgets('check when no messages are present', (tester) async {
      final chatListCardWidget = MaterialApp(
        home: Scaffold(
          body: ChatListCard(
            channelChatData: ChannelChatData(
              channelId: 'testChannelId',
              channelName: 'testChannelName',
              photoUrl: 'testPhotoUrl',
              recentMessageSentBy: null,
              recentMessageSentAt: null,
              recentMessageText: null,
              userIds: ['testUserId'],
            ),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListCardWidget));

      expect(find.text('testRecentMessageSentBy: testRecentMessageText'),
          findsNothing);
      expect(find.text('testRecentMessageSentBy shared file'), findsNothing);
      expect(find.text('No messages present yet!'), findsOneWidget);
    });

    testWidgets('check when image was shared', (tester) async {
      final chatListCardWidget = MaterialApp(
        home: Scaffold(
          body: ChatListCard(
            channelChatData: ChannelChatData(
              channelId: 'testChannelId',
              channelName: 'testChannelName',
              photoUrl: 'testPhotoUrl',
              recentMessageSentBy: 'testRecentMessageSentBy',
              recentMessageSentAt: DateTime(2021, 12, 30),
              recentMessageText: '',
              userIds: ['testUserId'],
            ),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListCardWidget));

      expect(find.text('testRecentMessageSentBy: testRecentMessageText'),
          findsNothing);
      expect(find.text('testRecentMessageSentBy shared file'), findsOneWidget);
      expect(find.text('No messages present yet!'), findsNothing);
    });

    test('getFormattedDate returns correctly', () {
      final card = ChatListCard(
        channelChatData: ChannelChatData(
          channelId: 'testChannelId',
          channelName: 'testChannelName',
          photoUrl: 'testPhotoUrl',
          recentMessageSentBy: 'testRecentMessageSentBy',
          recentMessageSentAt: DateTime(2021, 12, 30),
          recentMessageText: '',
          userIds: ['testUserId'],
        ),
      );

      final now = DateTime(2000, 1, 1);

      final today = card.getFormattedDate(now, DateTime(2000, 1, 1));
      final oneDayAgo = card.getFormattedDate(now, DateTime(1999, 12, 31));
      final sevenDaysAgo = card.getFormattedDate(now, DateTime(1999, 12, 25));
      final oneWeekAgo = card.getFormattedDate(now, DateTime(1999, 12, 24));
      final twoWeeksAgo = card.getFormattedDate(now, DateTime(1999, 12, 17));
      final tenWeeksAgo = card.getFormattedDate(now, DateTime(1999, 10, 23));
      final elevenWeeksAgo = card.getFormattedDate(now, DateTime(1999, 10, 16));

      expect(today, 'Today');
      expect(oneDayAgo, '1 day ago');
      expect(sevenDaysAgo, '7 days ago');
      expect(oneWeekAgo, '1 week ago');
      expect(twoWeeksAgo, '2 weeks ago');
      expect(tenWeeksAgo, '10 weeks ago');
      expect(elevenWeeksAgo, '2 months ago');
    });
  });
}
