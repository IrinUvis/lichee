import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/screens/add_channel/add_channel_screen.dart';
import 'channel_list_screen_test.dart';
import 'providers/authentication_provider_test.dart';
import 'setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import 'setup/auth_mock_setup/mock_user.dart';
import 'setup/auth_mock_setup/mock_user_credential.dart';

Widget createAddChannelScreen() => const MaterialApp(
      home: AddChannelScreen(),
    );

void main() async {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Add channel screen Tests', () {
    testWidgets('Test if add channel screen shows up', (tester) async {
      await tester.pumpWidget(createAddChannelScreen());
      expect(find.byType(Column), findsOneWidget);
    });
  });
}
