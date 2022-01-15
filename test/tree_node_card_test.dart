import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_list/tree_node_card.dart';
import 'channel_list_screen_test.dart';

List<String>? childrenEmpty = List.empty();
List<String>? childrenNotEmpty = ['test'];

Widget createTreeNodeCardChannel(List<String>? children) => MaterialApp(
  home: Scaffold(
    body: TreeNodeCard(name: 'Test', type: 'channel', childrenIds: children),
  ),
);

Widget createTreeNodeCardCategory(List<String>? children) => MaterialApp(
  home: Scaffold(
    body: TreeNodeCard(name: 'Test2', type: 'category', childrenIds: children),
  ),
);


void main() async {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Tree Node Card Tests', () {
    testWidgets('Test if Channel Node shows up', (tester) async {
      await tester.pumpWidget(createTreeNodeCardChannel(childrenEmpty));
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      expect(find.byIcon(Icons.chat), findsOneWidget);
      expect(find.text('empty'), findsNothing);
    });

    testWidgets('Test if empty Category Node shows up', (tester) async {
      await tester.pumpWidget(createTreeNodeCardCategory(childrenEmpty));
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Test2'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.text('empty'), findsOneWidget);
    });

    testWidgets('Test if not empty Category Node shows up', (tester) async {
      await tester.pumpWidget(createTreeNodeCardCategory(childrenNotEmpty));
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Test2'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.text('empty'), findsNothing);
    });
  });
}