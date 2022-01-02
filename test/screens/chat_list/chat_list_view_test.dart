import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/channel_chat_data.dart';
import 'package:lichee/screens/chat_list/chat_list_card.dart';
import 'package:lichee/screens/chat_list/chat_list_view.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  final _firestore = FakeFirebaseFirestore();

  group('ChatListScreen', () {
    testWidgets('check initial state when no auth', (tester) async {
      final chatListView = MaterialApp(
        home: Scaffold(
          body: ChatListView(
            firestore: _firestore,
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListView));

      expect(find.byType(ChatListView), findsOneWidget);
      expect(find.byType(ChatListCard), findsNothing);
    });

    testWidgets('check search input and streams work as intended', (tester) async {
      final chatListView = MaterialApp(
        home: Scaffold(
          body: ChatListView(
            firestore: _firestore,
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListView));

      expect(find.byType(ChatListView), findsOneWidget);
      expect(find.byType(ChatListCard), findsNothing);

      _firestore.collection('channel_chats').add(ChannelChatData(
            channelId: 'testChannelId1',
            channelName: 'testChannelName1',
            photoUrl: 'testPhotoUrl1',
            userIds: ['2bGoqMTi4URGrGT9foi67zDqT6B3'],
          ).toMap());

      _firestore.collection('channel_chats').add(ChannelChatData(
            channelId: 'testChannelId2',
            channelName: 'testChannelName2',
            photoUrl: 'testPhotoUrl2',
            userIds: ['2bGoqMTi4URGrGT9foi67zDqT6B3'],
          ).toMap());

      await mockNetworkImagesFor(() => tester.pumpAndSettle());

      await tester.pumpAndSettle();
      expect(find.byType(ChatListCard), findsNWidgets(2));

      await tester.enterText(find.byType(TextField), 'nothing found');

      await tester.pumpAndSettle();
      expect(find.byType(ChatListCard), findsNothing);
    });
  });
}
