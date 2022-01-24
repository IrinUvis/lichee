import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/domain/channel.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/update/update_channel.dart';

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
  final channel2 = Channel(
    channelId: 'testId',
    channelName: 'differentChannelName',
    ownerId: 'anotherOwner',
    channelImageURL: 'someURL',
    createdOn: DateTime.now(),
    city: 'testCity2',
    isPromoted: false,
    userIds: ['testUser'],
    description: 'noDescription',
  );
  group('update channel tests', () {
    test('update Channel', () async {
      final _service = UpdateChannelService(firestore: _firestore);
      _firestore.collection('channels').add({
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
      _firestore.collection('channels').doc(channel1.channelId).set({
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

      final outcome = await _service.updateChannelById(channel1.channelId, channel2);
      expect(outcome.channelId, channel2.channelId);
      expect(outcome.channelName, 'differentChannelName');
      expect(outcome.description, channel2.description);
      expect(outcome.city, channel1.city);
    });

  });
}