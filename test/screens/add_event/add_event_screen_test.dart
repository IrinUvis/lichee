import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/add_event/add_event_screen.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  late final Provider<FirebaseProvider> addEventScreen;

  setUpAll(() async {
    final _firestore = FakeFirebaseFirestore();
    final _auth = MockFirebaseAuth();
    final _storage = StorageService(MockFirebaseStorage());

    await _firestore.collection('categories').doc('5xugsbjUdNN4DC50h2Db').set({
      'childrenIds': List.empty(),
      'isLastCategory': true,
      'name': 'testCategory',
      'parentId': 'testParentId',
      'type': 'category'
    });

    final eventData = AddEventNavigationParams(
        channelId: 'testChannelId', channelName: 'testChannelName');

    final addEventWidget = AddEventScreen(data: eventData);

    addEventScreen = Provider<FirebaseProvider>(
      create: (_) => FirebaseProvider(
        auth: _auth,
        firestore: _firestore,
        storage: _storage,
      ),
      child: MaterialApp(
        home: Scaffold(
          body: addEventWidget,
        ),
      ),
    );
  });

  testWidgets('check initial state of add event screen', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addEventScreen));
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });

  testWidgets('check if text is validated for empty text fields',
      (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addEventScreen));

    final createButtonFinder = find.byKey(const Key('createButton'));

    await tester.ensureVisible(createButtonFinder);
    await tester.tap(createButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Event title cannot be empty'), findsOneWidget);
    expect(find.text('Localization cannot be empty'), findsOneWidget);
    expect(find.text('You have to choose date and time of the event'),
        findsOneWidget);
  });

  testWidgets('check if text is validated for wrong characters number',
      (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addEventScreen));

    final titleFieldFinder = find.byKey(const Key('titleField'));
    final localizationFieldFinder = find.byKey(const Key('localizationField'));
    final createButtonFinder = find.byKey(const Key('createButton'));

    await tester.enterText(titleFieldFinder, 't');
    await tester.enterText(localizationFieldFinder, 't');

    await tester.ensureVisible(createButtonFinder);
    await tester.tap(createButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('t'), findsNWidgets(2));
    expect(find.text('Enter valid event title (min. 3 characters)'),
        findsOneWidget);
    expect(find.text('Enter valid localization (min. 3 characters)'),
        findsOneWidget);
    expect(find.text('You have to choose date and time of the event'),
        findsOneWidget);
  });

  testWidgets('check if date and time appear', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addEventScreen));

    final screenState =
        tester.state<AddEventScreenState>(find.byType(AddEventScreen));

    screenState.eventDate.date = DateTime(2022, 30, 1);
    screenState.eventDate.time = const TimeOfDay(hour: 10, minute: 30);
    expect(find.text('Select date'), findsOneWidget);
    expect(find.text('Select time'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(screenState.eventDate.date, isNotNull);
    expect(screenState.eventDate.time, isNotNull);

    await tester.pumpAndSettle();
    //expect(find.text('30/01/2000'), findsOneWidget);
    //expect(find.text('10:30'), findsOneWidget);
    expect(screenState.eventDate.date, DateTime(2022, 30, 1));
    expect(screenState.eventDate.time, const TimeOfDay(hour: 10, minute: 30));
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });

  testWidgets('test creating event', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addEventScreen));
    final screenState =
    tester.state<AddEventScreenState>(find.byType(AddEventScreen));

    final titleFieldFinder = find.byKey(const Key('titleField'));
    final localizationFieldFinder = find.byKey(const Key('localizationField'));

    final createButtonFinder = find.byKey(const Key('createButton'));

    await tester.enterText(titleFieldFinder, 'testName');
    await tester.enterText(localizationFieldFinder, 'testLocalization');
    screenState.eventDate.date = DateTime(2022, 30, 1);
    screenState.eventDate.time = const TimeOfDay(hour: 10, minute: 30);

    await tester.pumpAndSettle();
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.ensureVisible(createButtonFinder);
    await tester.tap(createButtonFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('test category and image button', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addEventScreen));

    final imageButtonFinder = find.byKey(const Key('imageButton'));
    final categoryButtonFinder = find.byKey(const Key('categoryButton'));

    await tester.tap(imageButtonFinder);
    await tester.tap(categoryButtonFinder);
    expect(imageButtonFinder, findsOneWidget);
    expect(categoryButtonFinder, findsOneWidget);
  });
}
