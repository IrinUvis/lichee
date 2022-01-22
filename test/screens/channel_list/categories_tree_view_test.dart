import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel_list/categories_tree_view.dart';
import 'package:lichee/screens/channel_list/tree_node_card.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';
import 'categories_channels_mock_firestore.dart';

void main() {
  late final Provider<FirebaseProvider> categoriesTreeViewScreen;
  late final FakeFirebaseFirestore _firestore;
  late final MockFirebaseAuth _auth;
  late final StorageService _storage;

  setUpAll(() async {
    _firestore = FakeFirebaseFirestore();
    _auth = MockFirebaseAuth();
    _storage = StorageService(MockFirebaseStorage());

    CategoriesChannelsMockFirestore.setUpMockFirestore(_firestore);

    const categoriesTreeViewWidget = CategoriesTreeView(
      isChoosingCategoryForChannelAddingAvailable: false,
    );

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
    await mockNetworkImagesFor(() => tester.pumpWidget(categoriesTreeViewScreen));
    
    await tester.pumpAndSettle();

    final homeButtonFinder = find.byKey(const Key('homeButton'));
    final citiesButtonFinder = find.byKey(const Key('citiesButton'));
    final returnButtonFinder = find.byKey(const Key('returnButton'));

    expect(homeButtonFinder, findsOneWidget);
    expect(citiesButtonFinder, findsOneWidget);
    expect(returnButtonFinder, findsOneWidget);

    expect(find.byType(TreeNodeCard), findsNWidgets(4));
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Football'), findsOneWidget);
    expect(find.text('Volleyball'), findsOneWidget);
    expect(find.text('Basketball'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_right), findsNWidgets(4));
    expect(find.byIcon(Icons.category), findsNWidgets(4));
    expect(find.text('empty'), findsNWidgets(1));

    await tester.ensureVisible(citiesButtonFinder);
    await tester.tap(citiesButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text('Lodz'), findsOneWidget);
    expect(find.text('Zgierz'), findsOneWidget);
  });
}
