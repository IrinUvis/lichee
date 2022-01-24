import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/channels/domain/channel.dart';
import 'package:lichee/channels/domain/channels_repository.dart';

void main() {
  group('Channel repository test', () {
    final _firestore = FakeFirebaseFirestore();
    final _repository = ChannelRepository(firestore: _firestore);

    test('test adding channel', () async {
      final channel = Channel(
        channelId: 'testChannelInRepo',
        channelName: 'testNameInRepo',
        ownerId: 'owner',
        description: 'no description',
        isPromoted: true,
        createdOn: DateTime.now(),
        channelImageURL: 'noURL',
        userIds: ['test'],
        city: 'Gdynia',
      );
      final channelResult = await _repository.addChannel(channel: channel);
      expect(channelResult, isNotNull);
      expect(channelResult.ownerId, channel.ownerId);
      expect(channelResult.channelName, 'testNameInRepo');
      await _firestore.collection('channels').doc(channel.channelId).delete();
    });

    test('test if getting all channels works correctly', () async {
      final channel = Channel(
        channelId: 'channelIdTest',
        channelName: 'testingChannel',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: false,
      );
      final channelFromAdding = await _repository.addChannel(channel: channel);
      final listOfChannels = await _repository.getAllChannels();
      expect(listOfChannels, isNotNull);
      expect(listOfChannels.length, 1);
      await _firestore.collection('channels').doc(channel.channelId).delete();
    });

    test('test if getting by name works correctly', () async {
      final channel = Channel(
        channelId: 'channelIdTest',
        channelName: 'testingChannel',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: false,
      );
      final addedChannel = await _repository.addChannel(channel: channel);
      final gotChannel = await _repository.getByName(name: 'testingChannel');
      expect(gotChannel, isNotNull);
      expect(gotChannel[0].channelId, 'channelIdTest');
      await _firestore.collection('channels').doc(channel.channelId).delete();
    });

    test('test getting channel by city', () async {
      final channel = Channel(
        channelId: 'channelIdTest',
        channelName: 'testingChannel',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: false,
        city: 'Lodz',
      );
      final addedChannel = await _repository.addChannel(channel: channel);
      final gotChannels = await _repository.getByCity(city: 'Lodz');
      expect(gotChannels.isNotEmpty, true);
      expect(gotChannels[0].channelId, 'channelIdTest');
      await _firestore.collection('channels').doc(channel.channelId).delete();
    });

    test('get channels by owner', () async {
      final channelToAdd = Channel(
        channelId: 'channelIdTest',
        channelName: 'testingChannel',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: false,
        city: 'Lodz',
      );
      final addedChannel = await _repository.addChannel(channel: channelToAdd);
      final gotChannels = await _repository.getByOwner(owner: 'owner');
      expect(gotChannels.length, 1);
      await _firestore.collection('channels').doc(channelToAdd.channelId).delete();
    });

    test('get promoted channels', () async {
      final channelToAdd = Channel(
        channelId: 'channelIdTest',
        channelName: 'testingChannel',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: true,
        city: 'Lodz',
      );
      final anotherChannelToAdd = Channel(
        channelId: 'channelIdTest2',
        channelName: 'testingChannel2',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: true,
        city: 'Lodz',
      );
      final addedChannel = await _repository.addChannel(channel: channelToAdd);
      final addedSecondChannel = await _repository.addChannel(channel: anotherChannelToAdd);
      final promotedChannels = await _repository.getPromoted();
      expect(promotedChannels.length, 2);
      await _firestore.collection('channels').doc(channelToAdd.channelId).delete();
      await _firestore.collection('channels').doc(anotherChannelToAdd.channelId).delete();
    });

    test('get channel in which user is a member', () async {
      final channelToAdd = Channel(
        channelId: 'channelIdTest',
        channelName: 'testingChannel',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: true,
        city: 'Lodz',
      );
      final addedChannel = await _repository.addChannel(channel: channelToAdd);
      final gotChannels = await _repository.getChannelsOfUserWithId('userId');
      expect(gotChannels.length, 1);

      await _firestore.collection('channels').doc(channelToAdd.channelId).delete();
    });

    test('update a channel', () async {
      final initialListOfChannels = await _repository.getAllChannels();
      expect(initialListOfChannels.length, 0);
      final channelToAdd = Channel(
        channelId: 'channelIdTest',
        channelName: 'testingChannel',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: true,
        city: 'Lodz',
      );
      final updatedChannel = Channel(
        channelId: 'channelIdTest',
        channelName: 'smieszna nazwa kanalu',
        ownerId: 'owner',
        userIds: ['userId'],
        description: 'new description',
        channelImageURL: 'noimageurl',
        createdOn: DateTime.now(),
        isPromoted: true,
        city: 'Lodz',
      );
      final addedChannel = await _repository.addChannel(channel: channelToAdd);
      final updatedChannelThatIsUpdatedMore = await _repository.updateById(id: 'channelIdTest', updatedChannel: updatedChannel);
      expect(updatedChannelThatIsUpdatedMore.channelName, 'smieszna nazwa kanalu');
    });

  });
}
