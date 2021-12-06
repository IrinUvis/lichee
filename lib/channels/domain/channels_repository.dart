import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/channels/domain/channel.dart';

class ChannelRepository {
  final CollectionReference _channels =
      FirebaseFirestore.instance.collection('channels');

  Future<Channel> addChannel({required Channel channel}) async {
    final newChannel = await _channels
        .doc(channel.channelId)
        .set({
          'channelName': channel.channelName,
          'channelId': channel.channelId,
          'channelImageURL': channel.channelImageURL,
          'city': channel.city,
          'createdOn': channel.createdOn,
          'description': channel.description,
          'userIds': channel.userIds,
        })
        .then((value) => print("new channel added!!!"))
        .catchError((error) => print("failed!!!"));

    return getById(id: channel.channelId!);
  }

  Future<Channel> getById({required String id}) async {
    final channelReference = await _channels.doc(id).get();
    return _toChannel(id, channelReference.data() as Map<String, dynamic>);
  }

  Channel _toChannel(String id, Map<String, dynamic> data) {
    String name = data['channelName'];
    String image = data['channelImageURL'];
    String city = data['city'];
    Timestamp co = data['createdOn'];
    String desc = data['description'];
    String owner = data['ownerId'];
    List<String> members = List.from(data['userIds']);
    return Channel(
      channelId: id,
      channelName: name,
      ownerId: owner,
      userIds: members,
      description: desc,
      channelImageURL: image,
      createdOn: co.toDate(),
      city: city,
    );
  }
}
