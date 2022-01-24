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
  late final Provider<FirebaseProvider>
      categoriesTreeViewScreenChoosingAvailable;
  late final FakeFirebaseFirestore _firestore;
  late final MockFirebaseAuth _auth;
  late final StorageService _storage;

  late final Finder homeButtonFinder;
  late final Finder citiesButtonFinder;
  late final Finder returnButtonFinder;
  late final Finder chooseCategoryButtonFinder;

  setUpAll(() async {
    _firestore = FakeFirebaseFirestore();
    _auth = MockFirebaseAuth();
    _storage = StorageService(MockFirebaseStorage());

    CategoriesChannelsMockFirestore.setUpMockFirestore(_firestore);

    const categoriesTreeViewWidget = CategoriesTreeView(
      isChoosingCategoryForChannelAddingAvailable: false,
    );
    const categoriesTreeViewChoosingAvailableWidget = CategoriesTreeView(
      isChoosingCategoryForChannelAddingAvailable: true,
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

    categoriesTreeViewScreenChoosingAvailable = Provider<FirebaseProvider>(
      create: (_) => FirebaseProvider(
        auth: _auth,
        firestore: _firestore,
        storage: _storage,
      ),
      child: const MaterialApp(
        home: Scaffold(
          body: categoriesTreeViewChoosingAvailableWidget,
        ),
      ),
    );

    homeButtonFinder = find.byKey(const Key('homeButton'));
    citiesButtonFinder = find.byKey(const Key('citiesButton'));
    returnButtonFinder = find.byKey(const Key('returnButton'));
    chooseCategoryButtonFinder = find.byKey(const Key('chooseCategoryButton'));
  });

  group('Choosing category for channel adding unavailable', () {
    testWidgets('categories_tree_view - test highest categories level',
        (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreen));
      await tester.pumpAndSettle();

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

    testWidgets('categories_tree_view - test empty category', (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreen));
      await tester.pumpAndSettle();

      final runningCategoryFinder = find.text('Running');

      await tester.ensureVisible(runningCategoryFinder);
      await tester.tap(runningCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNothing);
      expect(find.text('This category is empty for now'), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
    });

    testWidgets('categories_tree_view - home button', (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreen));
      await tester.pumpAndSettle();
      final screenState = tester
          .state<CategoriesTreeViewState>(find.byType(CategoriesTreeView));

      final runningCategoryFinder = find.text('Running');

      await tester.ensureVisible(runningCategoryFinder);
      await tester.tap(runningCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNothing);
      expect(find.text('This category is empty for now'), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);

      await tester.ensureVisible(homeButtonFinder);
      await tester.tap(homeButtonFinder);
      await tester.pumpAndSettle();

      expect(screenState.parentId, '');
      expect(find.byType(TreeNodeCard), findsNWidgets(4));
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Football'), findsOneWidget);
      expect(find.text('Volleyball'), findsOneWidget);
      expect(find.text('Basketball'), findsOneWidget);
    });

    testWidgets('categories_tree_view - return button', (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreen));
      await tester.pumpAndSettle();
      final screenState = tester
          .state<CategoriesTreeViewState>(find.byType(CategoriesTreeView));

      final footballCategoryFinder = find.text('Football');
      final match3x3CategoryFinder = find.text('Match 3x3');

      await tester.ensureVisible(footballCategoryFinder);
      await tester.tap(footballCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsOneWidget);
      expect(find.text('Match 3x3'), findsOneWidget);

      await tester.ensureVisible(match3x3CategoryFinder);
      await tester.tap(match3x3CategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNWidgets(2));
      expect(find.text('Match in Lodz'), findsOneWidget);
      expect(find.text('Match in Zgierz'), findsOneWidget);

      await tester.ensureVisible(returnButtonFinder);
      await tester.tap(returnButtonFinder);
      await tester.pumpAndSettle();
      await tester.ensureVisible(returnButtonFinder);
      await tester.tap(returnButtonFinder);
      await tester.pumpAndSettle();

      expect(screenState.parentId, '');
      expect(find.byType(TreeNodeCard), findsNWidgets(4));
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Football'), findsOneWidget);
      expect(find.text('Volleyball'), findsOneWidget);
      expect(find.text('Basketball'), findsOneWidget);
    });

    testWidgets('categories_tree_view - test category with channel',
        (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreen));
      await tester.pumpAndSettle();

      final footballCategoryFinder = find.text('Football');
      final match3x3CategoryFinder = find.text('Match 3x3');

      await tester.ensureVisible(footballCategoryFinder);
      await tester.tap(footballCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsOneWidget);
      expect(find.text('Match 3x3'), findsOneWidget);

      await tester.ensureVisible(match3x3CategoryFinder);
      await tester.tap(match3x3CategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNWidgets(2));
      expect(find.text('Match in Lodz'), findsOneWidget);
      expect(find.text('Match in Zgierz'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right), findsNWidgets(2));
      expect(find.byIcon(Icons.chat), findsNWidgets(2));
      expect(find.text('empty'), findsNothing);
    });

    testWidgets('categories_tree_view - test channel filtering',
        (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreen));
      await tester.pumpAndSettle();

      final footballCategoryFinder = find.text('Football');
      final match3x3CategoryFinder = find.text('Match 3x3');
      final citySearchFieldFinder = find.byType(TextField);
      final lodzFilterFinder = find.text('Lodz');
      final applyFilterButtonFinder = find.text('Apply');

      await tester.ensureVisible(citiesButtonFinder);
      await tester.tap(citiesButtonFinder);
      await tester.pumpAndSettle();

      expect(citySearchFieldFinder, findsOneWidget);
      await tester.enterText(citySearchFieldFinder, 'Lod');
      await tester.tap(lodzFilterFinder);
      await tester.tap(applyFilterButtonFinder);
      await tester.pumpAndSettle();

      await tester.ensureVisible(footballCategoryFinder);
      await tester.tap(footballCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsOneWidget);
      expect(find.text('Match 3x3'), findsOneWidget);

      await tester.ensureVisible(match3x3CategoryFinder);
      await tester.tap(match3x3CategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNWidgets(1));
      expect(find.text('Match in Lodz'), findsOneWidget);
      expect(find.text('Match in Zgierz'), findsNothing);
      expect(find.byIcon(Icons.arrow_right), findsNWidgets(1));
      expect(find.byIcon(Icons.chat), findsNWidgets(1));
      expect(find.text('empty'), findsNothing);
    });
  });

  group('Choosing category for channel adding available', () {
    testWidgets('categories_tree_view - test highest categories level',
        (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreenChoosingAvailable));
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNWidgets(4));
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Football'), findsOneWidget);
      expect(find.text('Volleyball'), findsOneWidget);
      expect(find.text('Basketball'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right), findsNWidgets(4));
      expect(find.byIcon(Icons.category), findsNWidgets(4));
      expect(find.text('empty'), findsNWidgets(1));

      expect(chooseCategoryButtonFinder, findsNothing);

      await tester.ensureVisible(citiesButtonFinder);
      await tester.tap(citiesButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Lodz'), findsOneWidget);
      expect(find.text('Zgierz'), findsOneWidget);
    });

    testWidgets('categories_tree_view - test empty category', (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreen));
      await tester.pumpAndSettle();

      final runningCategoryFinder = find.text('Running');

      await tester.ensureVisible(runningCategoryFinder);
      await tester.tap(runningCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNothing);
      expect(find.text('This category is empty for now'), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);

      expect(chooseCategoryButtonFinder, findsNothing);
    });

    testWidgets('categories_tree_view - home button', (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreenChoosingAvailable));
      await tester.pumpAndSettle();
      final screenState = tester
          .state<CategoriesTreeViewState>(find.byType(CategoriesTreeView));

      final runningCategoryFinder = find.text('Running');

      await tester.ensureVisible(runningCategoryFinder);
      await tester.tap(runningCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNothing);
      expect(find.text('This category is empty for now'), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);

      await tester.ensureVisible(homeButtonFinder);
      await tester.tap(homeButtonFinder);
      await tester.pumpAndSettle();

      expect(screenState.parentId, '');
      expect(find.byType(TreeNodeCard), findsNWidgets(4));
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Football'), findsOneWidget);
      expect(find.text('Volleyball'), findsOneWidget);
      expect(find.text('Basketball'), findsOneWidget);
    });

    testWidgets('categories_tree_view - return button', (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreenChoosingAvailable));
      await tester.pumpAndSettle();
      final screenState = tester
          .state<CategoriesTreeViewState>(find.byType(CategoriesTreeView));

      final footballCategoryFinder = find.text('Football');
      final match3x3CategoryFinder = find.text('Match 3x3');

      await tester.ensureVisible(footballCategoryFinder);
      await tester.tap(footballCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsOneWidget);
      expect(find.text('Match 3x3'), findsOneWidget);

      await tester.ensureVisible(match3x3CategoryFinder);
      await tester.tap(match3x3CategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNWidgets(2));
      expect(find.text('Match in Lodz'), findsOneWidget);
      expect(find.text('Match in Zgierz'), findsOneWidget);

      await tester.ensureVisible(returnButtonFinder);
      await tester.tap(returnButtonFinder);
      await tester.pumpAndSettle();
      await tester.ensureVisible(returnButtonFinder);
      await tester.tap(returnButtonFinder);
      await tester.pumpAndSettle();

      expect(screenState.parentId, '');
      expect(find.byType(TreeNodeCard), findsNWidgets(4));
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Football'), findsOneWidget);
      expect(find.text('Volleyball'), findsOneWidget);
      expect(find.text('Basketball'), findsOneWidget);
    });

    testWidgets('categories_tree_view - test category with channel',
        (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreenChoosingAvailable));
      await tester.pumpAndSettle();

      final footballCategoryFinder = find.text('Football');
      final match3x3CategoryFinder = find.text('Match 3x3');

      await tester.ensureVisible(footballCategoryFinder);
      await tester.tap(footballCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsOneWidget);
      expect(find.text('Match 3x3'), findsOneWidget);

      await tester.ensureVisible(match3x3CategoryFinder);
      await tester.tap(match3x3CategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNWidgets(2));
      expect(find.text('Match in Lodz'), findsOneWidget);
      expect(find.text('Match in Zgierz'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right), findsNWidgets(2));
      expect(find.byIcon(Icons.chat), findsNWidgets(2));
      expect(find.text('empty'), findsNothing);

      expect(chooseCategoryButtonFinder, findsOneWidget);

      await tester.tap(chooseCategoryButtonFinder);
      await tester.pumpAndSettle();
    });

    testWidgets('categories_tree_view - test channel filtering',
        (tester) async {
      await mockNetworkImagesFor(
          () => tester.pumpWidget(categoriesTreeViewScreenChoosingAvailable));
      await tester.pumpAndSettle();

      final footballCategoryFinder = find.text('Football');
      final match3x3CategoryFinder = find.text('Match 3x3');
      final citySearchFieldFinder = find.byType(TextField);
      final lodzFilterFinder = find.text('Lodz');
      final applyFilterButtonFinder = find.text('Apply');

      await tester.ensureVisible(citiesButtonFinder);
      await tester.tap(citiesButtonFinder);
      await tester.pumpAndSettle();

      expect(citySearchFieldFinder, findsOneWidget);
      await tester.enterText(citySearchFieldFinder, 'Lod');
      await tester.tap(lodzFilterFinder);
      await tester.tap(applyFilterButtonFinder);
      await tester.pumpAndSettle();

      await tester.ensureVisible(footballCategoryFinder);
      await tester.tap(footballCategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsOneWidget);
      expect(find.text('Match 3x3'), findsOneWidget);

      await tester.ensureVisible(match3x3CategoryFinder);
      await tester.tap(match3x3CategoryFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TreeNodeCard), findsNWidgets(1));
      expect(find.text('Match in Lodz'), findsOneWidget);
      expect(find.text('Match in Zgierz'), findsNothing);
      expect(find.byIcon(Icons.arrow_right), findsNWidgets(1));
      expect(find.byIcon(Icons.chat), findsNWidgets(1));
      expect(find.text('empty'), findsNothing);
    });
  });
}
