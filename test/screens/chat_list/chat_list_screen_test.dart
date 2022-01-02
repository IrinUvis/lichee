import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/screens/auth/screens/not_logged_in_view.dart';
import 'package:lichee/screens/chat_list/chat_list_card.dart';
import 'package:lichee/screens/chat_list/chat_list_screen.dart';
import 'package:lichee/screens/chat_list/chat_list_view.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../setup/auth_mock_setup/mock_user.dart';

void main() {
  final _firestore = FakeFirebaseFirestore();

  group('ChatListScreen', () {
    testWidgets('check initial state when no auth', (tester) async {
      final chatListScreen = MaterialApp(
        home: Scaffold(
          body: ChatListScreen(
            firestore: _firestore,
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListScreen));

      expect(find.byType(NotLoggedInView), findsOneWidget);
    });

    testWidgets('check initial state when authorized', (tester) async {
      final chatListView = Provider<User?>(
        create: (context) => MockUser(uid: 'testUid'),
        child: MaterialApp(
          home: Scaffold(
            body: ChatListScreen(
              firestore: _firestore,
            ),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListView));

      expect(find.byType(ChatListView), findsOneWidget);
      expect(find.byType(ChatListCard), findsNothing);
    });
  });
}
