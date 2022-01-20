import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_list/categories_tree_view.dart';
import 'channel_list_screen_test.dart';

Widget createCategoriesTreeView(bool categoryChoosingAvailable) => MaterialApp(
      home: Scaffold(
        body: CategoriesTreeView(
          isChoosingCategoryForChannelAddingAvailable:
              categoryChoosingAvailable,
        ),
      ),
    );

void main() async {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // group('Categories Tree View Tests', () {
  //   testWidgets('Test if Categories Tree View shows up', (tester) async {
  //     await tester.pumpWidget(createCategoriesTreeView(false));
  //     expect(find.byType(Column), findsOneWidget);
  //     expect(find.byType(ElevatedButton), findsNWidgets(3));
  //     await tester.tap(find.byIcon(Icons.home));
  //     await tester.tap(find.byIcon(Icons.undo));
  //     expect(find.byType(Column), findsOneWidget);
  //     expect(find.byType(ElevatedButton), findsNWidgets(3));
  //   });
  //
  //   testWidgets(
  //       'Test if Categories Tree View with channel adding button shows up',
  //       (tester) async {
  //     await tester.pumpWidget(createCategoriesTreeView(true));
  //     expect(find.byType(Column), findsOneWidget);
  //     expect(find.byType(ElevatedButton), findsNWidgets(3));
  //     await tester.tap(find.byIcon(Icons.home));
  //     await tester.tap(find.byIcon(Icons.undo));
  //     expect(find.byType(Column), findsOneWidget);
  //     expect(find.byType(ElevatedButton), findsNWidgets(3));
  //   });
  // });
}
