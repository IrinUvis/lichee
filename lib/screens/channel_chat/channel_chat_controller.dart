import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/models/chat_message_data.dart';
import 'package:lichee/services/storage_service.dart';

class ChannelChatController {
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  ChannelChatController(this._firestore, this._storage);

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(
      String channelId) {
    return _firestore
        .collection('channel_messages/' + channelId + '/messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  Future<String> uploadPhoto({
    required String channelId,
    required DateTime currentTime,
    required File file,
  }) async {
    return await _storage.uploadFile(
        path: 'chats/' +
            channelId +
            '/' +
            currentTime.millisecondsSinceEpoch.toString(),
        file: file);
  }

  void sendMessage({
    required String channelId,
    required String userId,
    required String username,
    required String messageText,
    required String? imageUrl,
    required DateTime currentTime,
  }) {
    _firestore
        .collection('channel_messages/' + channelId + '/messages')
        .add(ChatMessageData(
          idSentBy: userId,
          nameSentBy: username,
          messageText: messageText,
          imageUrl: imageUrl,
          sentAt: currentTime,
        ).toMap());
  }

  void updateChatListWithMostRecentMessage(
      {required String channelId,
      required String messageText,
      required String username,
      required DateTime currentTime}) {
    FirebaseFirestore.instance
        .collection('channel_chats')
        .doc(channelId)
        .update({
      'recentMessageText': messageText,
      'recentMessageSentBy': username,
      'recentMessageSentAt': currentTime,
    });
  }
}
