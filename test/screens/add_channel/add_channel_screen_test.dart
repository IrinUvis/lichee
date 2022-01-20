import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/add_channel/add_channel_screen.dart';
import 'package:lichee/screens/auth/screens/not_logged_in_view.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/auth_mock_setup/mock_user.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  late final Provider<FirebaseProvider> addChannelScreenNoAuth;
  late final MultiProvider addChannelScreenAuth;

  setUpAll(() async {
    final _firestore = FakeFirebaseFirestore();
    final _auth = MockFirebaseAuth();
    final _storage = StorageService(MockFirebaseStorage());
    final _imagePicker = ImagePicker();

    await _firestore.collection('categories').doc('5xugsbjUdNN4DC50h2Db').set({
      'childrenIds': List.empty(),
      'isLastCategory': true,
      'name': 'testCategory',
      'parentId': 'testParentId',
      'type': 'category'
    });

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

  testWidgets('check initial screen state for logged in user', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenAuth));

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });

  testWidgets('check if text is validated for empty text fields',
      (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenAuth));

    final createButtonFinder = find.byKey(const Key('createButton'));

    await tester.ensureVisible(createButtonFinder);
    await tester.tap(createButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Channel name cannot be empty'), findsOneWidget);
    expect(find.text('City cannot be empty'), findsOneWidget);
    expect(find.text('Channel description cannot be empty'), findsOneWidget);
    expect(find.text('You have to choose channel image'), findsOneWidget);
    expect(find.text('You have to choose channel category'), findsOneWidget);
  });

  testWidgets('check if text is validated for wrong characters number',
      (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenAuth));

    final nameFieldFinder = find.byKey(const Key('nameField'));
    final cityFieldFinder = find.byKey(const Key('cityField'));
    final descriptionFieldFinder = find.byKey(const Key('descriptionField'));
    final createButtonFinder = find.byKey(const Key('createButton'));

    await tester.enterText(nameFieldFinder, 't');
    await tester.enterText(cityFieldFinder, 't');
    await tester.enterText(descriptionFieldFinder, 't');

    await tester.ensureVisible(createButtonFinder);
    await tester.tap(createButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('t'), findsNWidgets(3));
    expect(find.text('Enter valid channel name (min. 3 characters)'),
        findsOneWidget);
    expect(find.text('Enter valid city (min. 3 characters)'), findsOneWidget);
    expect(find.text('Enter valid channel description (min. 20 characters)'),
        findsOneWidget);
    expect(find.text('You have to choose channel image'), findsOneWidget);
    expect(find.text('You have to choose channel category'), findsOneWidget);
  });

  testWidgets('check if image appears', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenAuth));

    final screenState =
        tester.state<AddChannelScreenState>(find.byType(AddChannelScreen));

    screenState.file = File('./../../test_resources/test_file.jpg');
    screenState.chosenCategoryId = 'test';
    screenState.chosenCategoryName = 'test';

    await tester.pumpAndSettle();

    expect(find.text('test'), findsOneWidget);
    expect(screenState.file!.path, './../../test_resources/test_file.jpg');
    expect(screenState.chosenCategoryId, 'test');
    expect(screenState.chosenCategoryName, 'test');
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.close_outlined), findsNWidgets(2));

    await tester.tap(find.byKey(const Key('clearImage')));
    await tester.tap(find.byKey(const Key('clearCategory')));

    await tester.pump();

    final screenStateAfterImageClear =
        tester.state<AddChannelScreenState>(find.byType(AddChannelScreen));

    expect(screenStateAfterImageClear.file, isNull);
    expect(find.byIcon(Icons.close_outlined), findsNothing);
  });

  testWidgets('test creating channel', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenAuth));
    final screenState =
        tester.state<AddChannelScreenState>(find.byType(AddChannelScreen));

    final nameFieldFinder = find.byKey(const Key('nameField'));
    final cityFieldFinder = find.byKey(const Key('cityField'));
    final descriptionFieldFinder = find.byKey(const Key('descriptionField'));

    final imageButtonFinder = find.byKey(const Key('imageButton'));
    final categoryButtonFinder = find.byKey(const Key('categoryButton'));
    final createButtonFinder = find.byKey(const Key('createButton'));

    expect(imageButtonFinder, findsOneWidget);
    expect(categoryButtonFinder, findsOneWidget);

    await tester.enterText(nameFieldFinder, 'testName');
    await tester.enterText(cityFieldFinder, 'testCity');
    await tester.enterText(
        descriptionFieldFinder, 'testDescriptionTestDescription');
    screenState.file = File('./../../test_resources/test_file.jpg');
    screenState.chosenCategoryId = '5xugsbjUdNN4DC50h2Db';
    screenState.chosenCategoryName = 'testCategory';

    await tester.pumpAndSettle();

    await tester.ensureVisible(createButtonFinder);
    await tester.tap(createButtonFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('test category and image button', (tester) async {
  await mockNetworkImagesFor(() => tester.pumpWidget(addChannelScreenAuth));

  final imageButtonFinder = find.byKey(const Key('imageButton'));
  final categoryButtonFinder = find.byKey(const Key('categoryButton'));

  await tester.tap(imageButtonFinder);
  await tester.tap(categoryButtonFinder);
  expect(imageButtonFinder, findsOneWidget);
  expect(categoryButtonFinder, findsOneWidget);
  });
}
