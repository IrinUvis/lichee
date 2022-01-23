import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/screens/channel_list/tree_node_card.dart';

void main() {
  testWidgets('test tree node card - empty category', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TreeNodeCard(
              name: 'testCategory',
              type: 'category',
              childrenIds: List.empty()),
        ),
      ),
    );

    expect(find.text('testCategory'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_right), findsOneWidget);
    expect(find.text('empty'), findsOneWidget);
    expect(find.byIcon(Icons.category), findsOneWidget);
  });

  testWidgets('test tree node card - not empty category', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TreeNodeCard(
              name: 'testCategory',
              type: 'category',
              childrenIds: ['testChildId']),
        ),
      ),
    );

    expect(find.text('testCategory'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_right), findsOneWidget);
    expect(find.text('empty'), findsNothing);
    expect(find.byIcon(Icons.category), findsOneWidget);
  });

  testWidgets('test tree node card - channel', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TreeNodeCard(
            name: 'testChannel',
            type: 'channel',
            childrenIds: List.empty(),
          ),
        ),
      ),
    );

    expect(find.text('testChannel'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_right), findsOneWidget);
    expect(find.text('empty'), findsNothing);
    expect(find.byIcon(Icons.chat), findsOneWidget);
  });
}
