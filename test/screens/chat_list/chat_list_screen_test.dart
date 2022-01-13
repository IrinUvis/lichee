import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/auth/screens/not_logged_in_view.dart';
import 'package:lichee/screens/chat_list/chat_list_card.dart';
import 'package:lichee/screens/chat_list/chat_list_screen.dart';
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
    testWidgets('check initial state when no auth', (tester) async {
      const chatListScreen = MaterialApp(
        home: Scaffold(
          body: ChatListScreen(),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListScreen));

      expect(find.byType(NotLoggedInView), findsOneWidget);
    });

    testWidgets('check initial state when authorized', (tester) async {
      final chatListScreen = MultiProvider(
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
          ),
        ],
        child:  const MaterialApp(
          home: Scaffold(
            body: ChatListScreen(),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(chatListScreen));

      expect(find.byType(ChatListView), findsOneWidget);
      expect(find.byType(ChatListCard), findsNothing);
    });
  });
}
