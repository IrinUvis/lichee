import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/models/channel_chat_data.dart';
import 'package:lichee/services/storage_service.dart';

class AddChannelController {
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  AddChannelController(this._firestore, this._storage);

  Future<String> uploadPhoto({
    required String uuid,
    required DateTime currentTime,
    required File file,
  }) async {
    return await _storage.uploadFile(
        path: 'channels/' +
            uuid +
            '-' +
            currentTime.millisecondsSinceEpoch.toString(),
        file: file);
  }

  Future<void> addChannel(
      {required String channelName,
      required String imageUrl,
      required String city,
      required DateTime now,
      required String description,
      required List<String> usersIds,
      required String userId,
      required String parentCategoryId}) async {
    final newChannel = await _firestore.collection('channels').add({
      'channelName': channelName,
      'channelImageURL': imageUrl,
      'city': city,
      'createdOn': DateTime(now.year, now.month, now.day),
      'description': description,
      'userIds': usersIds,
      'ownerId': userId,
      'parentCategoryId': parentCategoryId,
    });

    await _firestore.collection('channel_chats').doc(newChannel.id).set(
        ChannelChatData(
                channelId: newChannel.id,
                channelName: channelName,
                photoUrl: imageUrl,
                userIds: usersIds)
            .toMap());

    await _firestore.collection('categories').doc(newChannel.id).set({
      'name': channelName,
      'type': 'channel',
      'parentId': parentCategoryId,
      'childrenIds': List.empty(),
      'isLastCategory': false,
    });

    final parentCategory =
        await _firestore.collection('categories').doc(parentCategoryId).get();
    Map<String, dynamic> parentCategoryMap =
        parentCategory.data() as Map<String, dynamic>;
    List<String> childrenIdsList = List.from(parentCategoryMap['childrenIds']);
    childrenIdsList.add(newChannel.id);
    await _firestore.collection('categories').doc(parentCategoryId).update({
      'childrenIds': childrenIdsList,
    });
  }

  Future<String> getCategoryNameById({required String channelParentId}) async {
    final parentCategory =
        await _firestore.collection('categories').doc(channelParentId).get();
    Map<String, dynamic> parentCategoryMap =
        parentCategory.data() as Map<String, dynamic>;
    String channelParentName = parentCategoryMap['name'];
    return channelParentName;
  }
}
