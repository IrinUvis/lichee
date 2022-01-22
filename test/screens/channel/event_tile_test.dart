import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/domain/channel.dart';
import 'package:lichee/channels/domain/channels_repository.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/components/event_tile.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/auth_mock_setup/mock_user.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  group('Event Tile test', () {
    final channel = Channel(
      channelId: 'channelId',
      channelName: 'channelName',
      ownerId: 'ownerId',
      channelImageURL: 'channelImageURL',
      createdOn: DateTime.now(),
      city: 'city',
      isPromoted: false,
      userIds: ['userId'],
      description: 'hello',
    );
    Map<String, dynamic> events = {
      'title': 'eventTitle',
      'localization': 'Lodz',
      'interestedUsers': [],
      'goingUsers': ['userId'],
      'date': Timestamp.now(),
    };
    final _firestore = FakeFirebaseFirestore();
    final _repository = ChannelRepository(firestore: _firestore);

    testWidgets('create event tile and press button', (tester) async {
      final _mock = MockUser(uid: 'helloFromTest');
      final _auth = MockFirebaseAuth(mockUser: _mock);
      await _repository.addChannel(channel: channel);
      final screen = MultiProvider(
        providers: [
          Provider<User?>(
            create: (_) => _mock,
          ),
          Provider<FirebaseProvider>(
            create: (_) => FirebaseProvider(
              auth: _auth,
              firestore: _firestore,
              storage: StorageService(MockFirebaseStorage()),
            ),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: EventTile(
              event: events,
              channelId: channel.channelId!,
            ),
          ),
        ),
      );
      await mockNetworkImagesFor(() => tester.pumpWidget(screen));
      await tester.pumpWidget(screen);
      final findEventTitle = find.text('eventTitle');
      expect(findEventTitle, findsOneWidget);
      expect(find.byIcon(Icons.star_outline), findsOneWidget);
    });

  });
}
