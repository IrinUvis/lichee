import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/update/update_channel.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/auth_mock_setup/mock_user.dart';
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
      userIds: ['testUser'],
      description: 'noDescription',
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

      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
      expect(find.text('Report'), findsOneWidget);
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'hello from Test');
      await tester.pump();
      expect(find.text('hello from Test'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
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
      await tester.tap(find.byIcon(Icons.more_horiz));
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

    testWidgets(
        'Logged in user joins the channel',
        (tester) async {
      final _firestore = FakeFirebaseFirestore();
      try {
        await _firestore.collection("channels").add({
          'channelName': channelDTO.channelName,
          'channelId': channelDTO.channelId,
          'channelImageURL': channelDTO.channelImageUrl,
          'city': channelDTO.city,
          'createdOn': channelDTO.createdOn,
          'isPromoted': channelDTO.isPromoted,
          'description': channelDTO.description,
          'userIds': channelDTO.userIds,
          'ownerId': channelDTO.ownerId,
        });

        await _firestore
            .collection("channels")
            .doc(channelDTO.channelId)
            .get()
            .then((value) {
          print(value.data()!['city']);
        });
      } catch (e) {
        _firestore.collection("channels").doc(channelDTO.channelId).update({
          'channelName': channelDTO.channelName,
          'channelId': channelDTO.channelId,
          'channelImageURL': channelDTO.channelImageUrl,
          'city': channelDTO.city,
          'createdOn': channelDTO.createdOn,
          'isPromoted': channelDTO.isPromoted,
          'description': channelDTO.description,
          'userIds': channelDTO.userIds,
          'ownerId': channelDTO.ownerId,
        });
      }
      final _mock = MockUser(uid: 'helloFromTest');
      final _auth = MockFirebaseAuth(mockUser: _mock);
      final _storage = StorageService(MockFirebaseStorage());
      final _updateService = UpdateChannelService(firestore: _firestore);
      final widget = ChannelScreen(
          channel: channelDTO, updateChannelService: _updateService);
      print(widget.updateChannelService);
      final screen = MultiProvider(
        providers: [
          Provider<User?>(
            create: (_) => _mock,
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
            body: widget,
          ),
        ),
      );
      _auth.signInWithEmailAndPassword(email: 'email', password: 'password');
      expect(_auth.currentUser!.uid, _mock.uid);
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      await tester.pumpWidget(screen);
      final button = find.ancestor(
          of: find.byIcon(Icons.group_add),
          matching:
              find.byWidgetPredicate((widget) => widget is ElevatedButton));
      expect(button.runtimeType, isNotNull);
      await tester.tap(button);
      await tester.idle();
      await tester.pumpAndSettle();
      expect(find.text("Joined"), findsOneWidget);
      final unjoin = find.byIcon(Icons.check_circle_outline);
      await tester.tap(unjoin);
      await tester.pumpAndSettle();
    });

    testWidgets('logged in users joins and removes themself from the channel', (tester) async {
      final _firestore = FakeFirebaseFirestore();
      try {
        await _firestore.collection("channels").add({
          'channelName': channelDTO.channelName,
          'channelId': channelDTO.channelId,
          'channelImageURL': channelDTO.channelImageUrl,
          'city': channelDTO.city,
          'createdOn': channelDTO.createdOn,
          'isPromoted': channelDTO.isPromoted,
          'description': channelDTO.description,
          'userIds': channelDTO.userIds,
          'ownerId': channelDTO.ownerId,
        });

        await _firestore
            .collection("channels")
            .doc(channelDTO.channelId)
            .get()
            .then((value) {
          print(value.data()!['city']);
        });
      } catch (e) {
        _firestore.collection("channels").doc(channelDTO.channelId).update({
          'channelName': channelDTO.channelName,
          'channelId': channelDTO.channelId,
          'channelImageURL': channelDTO.channelImageUrl,
          'city': channelDTO.city,
          'createdOn': channelDTO.createdOn,
          'isPromoted': channelDTO.isPromoted,
          'description': channelDTO.description,
          'userIds': channelDTO.userIds,
          'ownerId': channelDTO.ownerId,
        });
      }
      final _mock = MockUser(uid: 'helloFromTest');
      final _auth = MockFirebaseAuth(mockUser: _mock);
      final _storage = StorageService(MockFirebaseStorage());
      final _updateService = UpdateChannelService(firestore: _firestore);
      final widget = ChannelScreen(
          channel: channelDTO, updateChannelService: _updateService);
      final screen = MultiProvider(
        providers: [
          Provider<User?>(
            create: (_) => _mock,
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
            body: widget,
          ),
        ),
      );
      _auth.signInWithEmailAndPassword(email: 'email', password: 'password');
      expect(_auth.currentUser!.uid, _mock.uid);
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      await tester.pumpWidget(screen);
      final button = find.ancestor(
          of: find.byIcon(Icons.group_add),
          matching:
          find.byWidgetPredicate((widget) => widget is ElevatedButton));
      expect(button.runtimeType, isNotNull);
      await tester.tap(button);
      await tester.idle();
      await tester.pumpAndSettle();
      final unjoin = find.byIcon(Icons.check_circle_outline);
      await tester.tap(unjoin);
      await tester.pumpAndSettle();
      expect(find.text("Joined"), findsNothing);
    });
  });
}
