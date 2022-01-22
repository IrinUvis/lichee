import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel_list/categories_tree_view.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:provider/provider.dart';
import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  late final Provider<FirebaseProvider> categoriesTreeViewScreen;
  late final FakeFirebaseFirestore _firestore;
  late final MockFirebaseAuth _auth;
  late final StorageService _storage;

  setUpAll(() async {
    _firestore = FakeFirebaseFirestore();
    _auth = MockFirebaseAuth();
    _storage = StorageService(MockFirebaseStorage());

    await _firestore.collection('categories').doc('5xugsbjUdNN4DC50h2Db').set({
      'childrenIds': List.empty(),
      'isLastCategory': true,
      'name': 'testCategory',
      'parentId': 'testParentId',
      'type': 'category'
    });

    const categoriesTreeViewWidget = CategoriesTreeView(isChoosingCategoryForChannelAddingAvailable: false,);

    categoriesTreeViewScreen = Provider<FirebaseProvider>(
      create: (_) => FirebaseProvider(
        auth: _auth,
        firestore: _firestore,
        storage: _storage,
      ),
      child: const MaterialApp(
        home: Scaffold(
          body: categoriesTreeViewWidget,
        ),
      ),
    );
  });

  testWidgets('whatever', (tester) async {
    tester.pumpWidget(categoriesTreeViewScreen);
  });
}