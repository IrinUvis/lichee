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
  late final FakeFirebaseFirestore _firestore;
  late final MockFirebaseAuth _auth;
  late final StorageService _storage;
  late final AddEventNavigationParams eventData;

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

    eventData = AddEventNavigationParams(
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
    expect(find.byType(ElevatedButton), findsNWidgets(3));
    await tester.pumpAndSettle();

    await tester.ensureVisible(createButtonFinder);
    await tester.tap(createButtonFinder);
    await tester.pumpAndSettle();

    final snapshot = await _firestore.collection('events').doc(eventData.channelId).collection('events').get();
    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first.get('title'), 'testName');
    expect(snapshot.docs.first.get('localization'), 'testLocalization');
  });

  testWidgets('test date picking', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addEventScreen));
    final screenState =
    tester.state<AddEventScreenState>(find.byType(AddEventScreen));
    final datePickerFinder = find.byKey(const Key('datePicker'));
    final timePickerFinder = find.byKey(const Key('timePicker'));
    int day = DateTime.now().day;
    int month = DateTime.now().month;
    int year = DateTime.now().year;

    expect(datePickerFinder, findsOneWidget);
    expect(timePickerFinder, findsOneWidget);

    await tester.tap(datePickerFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text(day.toString()));
    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(datePickerFinder, findsOneWidget);
    expect(timePickerFinder, findsOneWidget);

    await tester.tap(timePickerFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));

    expect(screenState.eventDate.date!.day, day);
    expect(screenState.eventDate.date!.month, month);
    expect(screenState.eventDate.date!.year, year);
    expect(screenState.eventDate.time!.hour, 8);
    expect(screenState.eventDate.time!.minute, 0);
  });
}
