import 'dart:io';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/read/read_channel_service.dart';

void main() {
  final _firestore = FakeFirebaseFirestore();
  final channel1 = ReadChannelDto(
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
  final channel2 = ReadChannelDto(
    channelId: 'differentChannelId',
    channelName: 'differentChannelName',
    ownerId: 'anotherOwner',
    channelImageURL: 'someURL',
    createdOn: DateTime.now(),
    city: 'testCity2',
    isPromoted: false,
    userIds: ['testUser'],
    description: 'noDescription',
  );
  group('ReadChannelService', () {
    ReadChannelService readChannelService =
        ReadChannelService(firestore: _firestore);

    test('test getting channel by Id', () async {
      setup(_firestore, channel1, channel2);
      final output = await readChannelService.getById(id: channel1.channelId);
      expect(output.channelId, channel1.channelId);
      expect(output.channelName, channel1.channelName);
      expect(output.description, channel1.description);
      clean(_firestore);
    });

    test(
        'test getting channel by name assuming that there is only one channel with this name',
        () async {
      setup(_firestore, channel1, channel2);
      final output =
          await readChannelService.getByName(name: 'differentChannelName');
      expect(output[0].channelName, channel2.channelName);
      expect(output[0].description, channel2.description);
      clean(_firestore);
    });

    test('test getting by city', () async {
      setup(_firestore, channel1, channel2);
      var output = await readChannelService.getByCity(city: 'testCity');
      expect(output.length, 2);
      expect(output[0].city, 'testCity');
      clean(_firestore);
    });

    test('test getting all channels', () async {
      setup(_firestore, channel1, channel2);
      var output = await readChannelService.getAll();
      expect(output.length, 4);
      clean(_firestore);
    });

    test('test getting by owner', () async {
      setup(_firestore, channel1, channel2);
      final output = await readChannelService.getByOwner(owner: 'anotherOwner');
      expect(output.length, 2);
      clean(_firestore);
    });

    test('test getting promoted channels', () async {
      setup(_firestore, channel1, channel2);
      final output = await readChannelService.getPromoted();
      expect(output.length, 0);
      clean(_firestore);
    });

    test('get if user is added to channel', () async {
      setup(_firestore, channel1, channel2);
      final output = await readChannelService.getIfUserIsInTheChannelById(channel1.channelId, 'testUser');
      expect(output, true);
      clean(_firestore);
    });

    test('get channels in which user is a member', () async {
      setup(_firestore, channel1, channel2);
      final output = await readChannelService.getChannelsOfUserWithId('testUser');
      expect(output.length, 4);
      clean(_firestore);
    });
  });
}

void setup(FakeFirebaseFirestore firestore, ReadChannelDto channel1,
    ReadChannelDto channel2) {
  firestore.collection('channels').add({
    'channelId': channel1.channelId,
    'channelName': channel1.channelName,
    'ownerId': channel1.ownerId,
    'channelImageURL': channel1.channelImageUrl,
    'createdOn': channel1.createdOn,
    'city': channel1.city,
    'isPromoted': channel1.isPromoted,
    'userIds': channel1.userIds,
    'description': channel1.description
  });
  firestore.collection('channels').doc(channel1.channelId).set({
    'channelId': channel1.channelId,
    'channelName': channel1.channelName,
    'ownerId': channel1.ownerId,
    'channelImageURL': channel1.channelImageUrl,
    'createdOn': channel1.createdOn,
    'city': channel1.city,
    'isPromoted': channel1.isPromoted,
    'userIds': channel1.userIds,
    'description': channel1.description
  });
  firestore.collection('channels').add({
    'channelId': channel2.channelId,
    'channelName': channel2.channelName,
    'ownerId': channel2.ownerId,
    'channelImageURL': channel2.channelImageUrl,
    'createdOn': channel2.createdOn,
    'city': channel2.city,
    'isPromoted': channel2.isPromoted,
    'userIds': channel2.userIds,
    'description': channel2.description
  });
  firestore.collection('channels').doc(channel2.channelId).set({
    'channelId': channel2.channelId,
    'channelName': channel2.channelName,
    'ownerId': channel2.ownerId,
    'channelImageURL': channel2.channelImageUrl,
    'createdOn': channel2.createdOn,
    'city': channel2.city,
    'isPromoted': channel2.isPromoted,
    'userIds': channel2.userIds,
    'description': channel2.description
  });
}

void clean(FakeFirebaseFirestore firestore) async {
  firestore.collection('channels').get().then((snapshot) {
    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  });
}
