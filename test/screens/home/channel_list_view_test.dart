import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/domain/channel.dart';
import 'package:lichee/channels/domain/channels_repository.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/auth/screens/not_logged_in_view.dart';
import 'package:lichee/screens/home/channel_list_card.dart';
import 'package:lichee/screens/home/channel_list_view.dart';
import 'package:lichee/screens/home/home_screen_controller.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/auth_mock_setup/mock_user.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  group('Channel List View', () {
    final _auth = MockFirebaseAuth();
    final _firestore = FakeFirebaseFirestore();
    final _storage = MockFirebaseStorage();

    testWidgets('initializes correctly when user is not logged in',
        (tester) async {
      final channelList = MultiProvider(
        providers: [
          Provider<User?>(
            create: (_) => null,
          ),
          Provider<FirebaseProvider>(
            create: (_) => FirebaseProvider(
              auth: _auth,
              firestore: _firestore,
              storage: StorageService(_storage),
            ),
          ),

        ],
        child: MaterialApp(
          home: Scaffold(
            body: ChannelListView(
              homeScreenController: HomeScreenController(_firestore),
            ),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(channelList));

      expect(find.byType(NotLoggedInView), findsOneWidget);
    });

    testWidgets(
        'initializes correctly when user is logged in', (tester) async {
      final _channelRepository = ChannelRepository(firestore: _firestore);
      await _channelRepository.addChannel(
        channel: Channel(
          channelId: 'testChannelId',
          channelName: 'testChannelName',
          channelImageURL: 'testChannelImageUrl',
          city: 'testCity',
          createdOn: DateTime(2000),
          description: 'testDescription',
          isPromoted: true,
          ownerId: 'testOwnerId',
          userIds: ['testUserId'],
        ),
      );
      final channelList = MultiProvider(
        providers: [
          Provider<User?>(
            create: (_) => MockUser(uid: 'testUserId'),
          ),
          Provider<FirebaseProvider>(
            create: (_) => FirebaseProvider(
              auth: _auth,
              firestore: _firestore,
              storage: StorageService(_storage),
            ),
          ),

        ],
        child: MaterialApp(
          home: Scaffold(
            body: ChannelListView(
              homeScreenController: HomeScreenController(_firestore),
            ),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(channelList));

      await mockNetworkImagesFor(() => tester.pumpAndSettle());

      expect(find.byType(ChannelListCard), findsOneWidget);
    });
  });
}
