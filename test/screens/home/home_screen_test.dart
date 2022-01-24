import 'package:carousel_slider/carousel_slider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/domain/channel.dart';
import 'package:lichee/channels/domain/channels_repository.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/home/home_screen.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../setup/auth_mock_setup/firebase_auth_mocks_base.dart';
import '../../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  group('Home Screen', () {
    final _auth = MockFirebaseAuth();
    final _firestore = FakeFirebaseFirestore();
    final _storage = MockFirebaseStorage();

    testWidgets('initializes correctly when there are no promoted channels',
        (tester) async {
      final homeScreen = Provider<FirebaseProvider>(
        create: (_) => FirebaseProvider(
          auth: _auth,
          firestore: _firestore,
          storage: StorageService(_storage),
        ),
        child: MaterialApp(
          home: Scaffold(
            body: HomeScreen(),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(homeScreen));

      expect(find.byType(CarouselSlider), findsNothing);
    });

    testWidgets(
        'initializes correctly when there is at least one promoted channel',
        (tester) async {
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
          userIds: List.empty(),
        ),
      );

      final homeScreen = Provider<FirebaseProvider>(
        create: (_) => FirebaseProvider(
          auth: _auth,
          firestore: _firestore,
          storage: StorageService(_storage),
        ),
        child: MaterialApp(
          home: Scaffold(
            body: HomeScreen(),
          ),
        ),
      );

      await mockNetworkImagesFor(() => tester.pumpWidget(homeScreen));

      await mockNetworkImagesFor(() => tester.pumpAndSettle());

      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);

      final img = tester.widget(find.byType(Image));
      expect(
        img,
        isA<Image>().having(
          (image) => image.image,
          'image',
          isA<NetworkImage>()
              .having((ni) => ni.url, 'url', 'testChannelImageUrl'),
        ),
      );
      expect(find.text('testChannelName'), findsOneWidget);

      _firestore.removeSavedDocument('channels/testChannelId');
    });
  });
}
