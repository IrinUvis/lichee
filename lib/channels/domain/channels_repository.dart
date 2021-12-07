import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/channels/domain/channel.dart';

class ChannelRepository {
  final CollectionReference _channels =
      FirebaseFirestore.instance.collection('channels');

  Future<Channel> addChannel({required Channel channel}) async {
    final newChannel = await _channels.doc(channel.channelId).set({
      'channelName': channel.channelName,
      'channelId': channel.channelId,
      'channelImageURL': channel.channelImageURL,
      'city': channel.city,
      'createdOn': channel.createdOn,
      'description': channel.description,
      'userIds': channel.userIds,
      'ownerId': channel.ownerId,
    });
    return getById(id: channel.channelId!);
  }

  Future<Channel> getById({required String id}) async {
    final channelReference = await _channels.doc(id).get();
    return _toChannel(id, channelReference.data() as Map<String, dynamic>);
  }

  Future<List<Channel>> getAllChannels() async {
    List<Channel> channels = [];

    await _channels.get().then((value) {
      for (var element in value.docs) {
        channels.add(
            _toChannel(element.id, element.data() as Map<String, dynamic>));
      }
      return channels;
    });
    return channels;
  }

  Future<List<Channel>> getByName({required String name}) async {
    final channelReference =
        await _channels.where('channelName', isEqualTo: name).get();
    return channelReference.docs
        .map((channel) =>
            _toChannel((channel.id), channel.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Channel>> getByCity({required String city}) async {
    final channelReference =
        await _channels.where('city', isEqualTo: city).get();
    return channelReference.docs
        .map((channel) =>
            _toChannel((channel.id), channel.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Channel>> getByOwner({required String owner}) async {
    final channelReference =
        await _channels.where('ownerId', isEqualTo: owner).get();
    return channelReference.docs
        .map((channel) =>
            _toChannel((channel.id), channel.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Channel>> getPromoted() async {
    final channelReference =
        await _channels.where('isPromoted', isEqualTo: true).get();
    return channelReference.docs
        .map((channel) =>
            _toChannel((channel.id), channel.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Channel> updateById(
      {required String id, required Channel updatedChannel}) async {
    await _channels.doc(id).update({
      'description': updatedChannel.description,
      'channelImageURL': updatedChannel.channelImageURL,
      'userIds': updatedChannel.userIds,
      'channelName': updatedChannel.channelName,
      'ownerId': updatedChannel.ownerId,
      'isPromoted': updatedChannel.isPromoted,
    });
    return getById(id: id);
  }

  Channel _toChannel(String id, Map<String, dynamic> data) {
    String name = data['channelName'].toString();
    String image = data['channelImageURL'].toString();
    String city = data['city'].toString();
    Timestamp co = data['createdOn'];
    String desc = data['description'].toString();
    String owner = data['ownerId'].toString();
    List<String> members = List.from(data['userIds']);
    bool isPromoted = data['isPromoted'] ?? false;

    return Channel(
      channelId: id,
      channelName: name,
      ownerId: owner,
      userIds: members,
      description: desc,
      channelImageURL: image,
      createdOn: co.toDate(),
      city: city,
      isPromoted: isPromoted,
    );
  }
}
