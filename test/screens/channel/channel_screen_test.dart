import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/components/channel_backgroud_photo.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  group('ChannelScreen', () {
    final channelDTO = ReadChannelDto(
      channelId: 'testId',
      channelName: 'testDataName',
      ownerId: 'testOwner',
      channelImageURL: 'testURL',
      createdOn: DateTime.now(),
      city: 'testCity',
      isPromoted: false,
      userIds: [' '],
      description: '',
    );

    testWidgets('Test if the screen is created properly', (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _auth = MockFirebaseAuth();
      final _storage = StorageService(MockFirebaseStorage());

      final widget = ChannelScreen(channel: channelDTO);
      final screen = Provider<FirebaseProvider>(
        create: (_) => FirebaseProvider(
          auth: _auth,
          firestore: _firestore,
          storage: _storage,
        ),
        child: MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      expect(find.byType(ChannelScreen), findsOneWidget);
    });

    testWidgets(
        'Create a screen with a channel and see if it\'s displayed correctly',
        (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _auth = MockFirebaseAuth();
      final _storage = StorageService(MockFirebaseStorage());

      final widget = ChannelScreen(channel: channelDTO);
      final screen = Provider<FirebaseProvider>(
        create: (_) => FirebaseProvider(
          auth: _auth,
          firestore: _firestore,
          storage: _storage,
        ),
        child: MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      await tester.pumpWidget(screen);
      final titleFinder = find.text('testDataName');
      expect(titleFinder, findsNWidgets(2));
    });

    testWidgets(
        'Anon tries to join to channel but cannot as they are not logged in',
        (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _auth = MockFirebaseAuth();
      final _storage = StorageService(MockFirebaseStorage());

      final widget = ChannelScreen(channel: channelDTO);
      final screen = Provider<FirebaseProvider>(
        create: (_) => FirebaseProvider(
          auth: _auth,
          firestore: _firestore,
          storage: _storage,
        ),
        child: MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      await tester.pumpWidget(screen);
      final button = find.ancestor(
          of: find.byIcon(Icons.group_add),
          matching:
              find.byWidgetPredicate((widget) => widget is ElevatedButton));
      expect(button.runtimeType, isNotNull);
      await tester.tap(button);
      expect(find.text("Join"), findsOneWidget);
    });

    testWidgets('Report channel and cancel reporting', (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _auth = MockFirebaseAuth();
      final _storage = StorageService(MockFirebaseStorage());
      final widget = ChannelScreen(channel: channelDTO);
      final screen = Provider<FirebaseProvider>(
        create: (_) => FirebaseProvider(
          auth: _auth,
          firestore: _firestore,
          storage: _storage,
        ),
        child: MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      await tester.pumpWidget(screen);
      final popupMenu = find.byIcon(Icons.more_horiz);
      expect(popupMenu, findsOneWidget);
      await tester.tap(popupMenu);
      await tester.pumpAndSettle();
      var childButton = find.text('Report');
      expect(childButton, findsOneWidget);
      await tester.tap(childButton);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'hello from Test');
      await tester.pump();
      expect(find.text('hello from Test'), findsOneWidget);
      var cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      expect(find.text('hello from Test'), findsNothing);
    });

    testWidgets('Report channel and send it', (tester) async {
      final _firestore = FakeFirebaseFirestore();
      final _auth = MockFirebaseAuth();
      final _storage = StorageService(MockFirebaseStorage());
      final widget = ChannelScreen(channel: channelDTO);
      final screen = Provider<FirebaseProvider>(
        create: (_) => FirebaseProvider(
          auth: _auth,
          firestore: _firestore,
          storage: _storage,
        ),
        child: MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      await tester.pumpWidget(screen);
      final popupMenu = find.byIcon(Icons.more_horiz);
      expect(popupMenu, findsOneWidget);
      await tester.tap(popupMenu);
      await tester.pumpAndSettle();
      var childButton = find.text('Report');
      expect(childButton, findsOneWidget);
      await tester.tap(childButton);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'hello from Test');
      await tester.pumpAndSettle();
      var sendButton = find.text('Send');
      await tester.tap(sendButton);
      await tester.pumpAndSettle();
      expect(find.text('hello from Test'), findsNothing);
    });

  });
}