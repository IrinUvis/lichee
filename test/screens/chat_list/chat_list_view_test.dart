import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/channel_chat_data.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/chat_list/chat_list_card.dart';
import 'package:lichee/screens/chat_list/chat_list_view.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication_provider_test.dart';
import '../../setup/auth_mock_setup/mock_user.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  final _auth = FakeFirebaseAuth();
  final _firestore = FakeFirebaseFirestore();
  final _storage = MockFirebaseStorage();

  group('ChatListScreen', () {
    testWidgets('check initial state', (tester) async {
      final chatListView = MultiProvider(
        providers: [
          Provider<User?>(
            create: (_) => MockUser(uid: 'testUid'),
          ),
          Provider<FirebaseProvider>(
            create: (_) => FirebaseProvider(
              auth: _auth,
              firestore: _firestore,
              storage: StorageService(_storage),
            ),
          )
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ChatListView(),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListView));

      expect(find.byType(ChatListView), findsOneWidget);
      expect(find.byType(ChatListCard), findsNothing);
    });

    testWidgets('check search input and streams work as intended', (tester) async {
      final chatListView = MultiProvider(
        providers: [
          Provider<User?>(
            create: (_) => MockUser(uid: 'testUid'),
          ),
          Provider<FirebaseProvider>(
            create: (_) => FirebaseProvider(
              auth: _auth,
              firestore: _firestore,
              storage: StorageService(_storage),
            ),
          )
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ChatListView(),
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
            userIds: ['testUid'],
          ).toMap());

      _firestore.collection('channel_chats').add(ChannelChatData(
        channelId: 'testChannelId2',
        channelName: 'testChannelName2',
        photoUrl: 'testPhotoUrl2',
        userIds: ['testUid'],
      ).toMap());

      _firestore.collection('channel_chats').add(ChannelChatData(
            channelId: 'testChannelId3',
            channelName: 'testChannelName3',
            photoUrl: 'testPhotoUrl3',
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
