import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/channels/domain/channel.dart';
import 'package:lichee/channels/domain/channels_repository.dart';

class UpdateChannelService {
  final ChannelRepository _repository;

  UpdateChannelService({
    required FirebaseFirestore firestore,
  }) : _repository = ChannelRepository(firestore: firestore);

  Future<Channel> updateChannelById(String id, Channel updatedChannel) async {
    final channel = await _repository.getById(id: id);
    channel.channelImageURL = updatedChannel.channelImageURL;
    channel.description = updatedChannel.description;
    channel.channelName = updatedChannel.channelName;
    channel.userIds = updatedChannel.userIds;
    final sameChannelButNew =
        await _repository.updateById(id: id, updatedChannel: channel);
    return sameChannelButNew;
  }

  Future<Channel> addUserToChannelById(String user, String channel) async {
    final gotChannel = await _repository.getById(id: channel);
    gotChannel.userIds!.add(user);
    final sameChannelButWithMoreMembers =
        await _repository.updateById(id: channel, updatedChannel: gotChannel);
    return sameChannelButWithMoreMembers;
  }

  Future<Channel> removeUserFromChannelById(String user, String channel) async {
    final gotChannel = await _repository.getById(id: channel);
    gotChannel.userIds!.remove(user);
    final sameChannelButWithLessMembers =
        await _repository.updateById(id: channel, updatedChannel: gotChannel);
    return sameChannelButWithLessMembers;
  }
}
