import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/add_channel/add_channel_screen.dart';
import 'package:lichee/screens/auth/screens/auth_screen.dart';
import 'package:lichee/screens/auth/screens/not_logged_in_view.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/auth_mock_setup/mock_user.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  late final Provider<FirebaseProvider> addChannelScreenNoAuth;
  late final MultiProvider addChannelScreenAuth;

  setUpAll(() {
    final _firestore = FakeFirebaseFirestore();
    final _auth = MockFirebaseAuth();
    final _storage = StorageService(MockFirebaseStorage());
    final _imagePicker = ImagePicker();

    final addChannelWidget = AddChannelScreen(imagePicker: _imagePicker);

    addChannelScreenNoAuth = Provider<FirebaseProvider>(
      create: (_) => FirebaseProvider(
        auth: _auth,
        firestore: _firestore,
        storage: _storage,
      ),
      child: MaterialApp(
        home: Scaffold(
          body: addChannelWidget,
        ),
      ),
    );

    addChannelScreenAuth = MultiProvider(
      providers: [
        Provider<User?>(
          create: (_) => MockUser(uid: 'testUid'),
        ),
        Provider<FirebaseProvider>(
          create: (_) => FirebaseProvider(
            auth: _auth,
            firestore: _firestore,
            storage: _storage,
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: addChannelWidget,
        ),
      ),
    );
  });

  testWidgets('check screen state for not logged in user', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenNoAuth));

    expect(find.byType(NotLoggedInView), findsNWidgets(1));
    expect(find.text('Adding channels or events unavailable'), findsOneWidget);
    expect(find.byType(MaterialButton), findsNWidgets(1));
    expect(find.text('Log in to add channel or event'), findsOneWidget);
  });

  testWidgets('check screen state for logged in user', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenAuth));

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });
}