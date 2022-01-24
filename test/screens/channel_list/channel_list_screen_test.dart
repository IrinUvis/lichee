import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel_list/categories_tree_view.dart';
import 'package:lichee/screens/channel_list/channel_list_screen.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:provider/provider.dart';
import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  late final Provider<FirebaseProvider> channeListScreen;
  late final FakeFirebaseFirestore _firestore;
  late final MockFirebaseAuth _auth;
  late final StorageService _storage;

  setUpAll(() async {
    _firestore = FakeFirebaseFirestore();
    _auth = MockFirebaseAuth();
    _storage = StorageService(MockFirebaseStorage());

    const channelListWidget = ChannelListScreen();

    channeListScreen = Provider<FirebaseProvider>(
      create: (_) => FirebaseProvider(
        auth: _auth,
        firestore: _firestore,
        storage: _storage,
      ),
      child: const MaterialApp(
        home: Scaffold(
          body: channelListWidget,
        ),
      ),
    );
  });

  testWidgets('channel list screen test', (tester) async {
    await tester.pumpWidget(channeListScreen);
    expect(find.byType(CategoriesTreeView), findsOneWidget);
  });
}
