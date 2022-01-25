import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/read/read_channel_service.dart';
import 'package:lichee/models/chat_message_data.dart';
import 'package:lichee/services/storage_service.dart';

class ChannelChatController {
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  final ReadChannelService _readChannelService;

  ChannelChatController(this._firestore, this._storage)
      : _readChannelService = ReadChannelService(firestore: _firestore);

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
    required ChatMessageData chatMessageData,
  }) {
    _firestore
        .collection('channel_messages/' + channelId + '/messages')
        .add(chatMessageData.toMap());
  }

  Future<ReadChannelDto> getParentChannelByChatId({
    required String chatId,
  }) {
    return _readChannelService.getById(id: chatId);
  }

  void updateChatListWithMostRecentMessage(
      {required String channelId,
      required String messageText,
      required String userId,
      required String username,
      required DateTime currentTime}) {
    _firestore.collection('channel_chats').doc(channelId).update({
      'recentMessageText': messageText,
      'recentMessageSentBy': username,
      'recentMessageSentByUserId': userId,
      'recentMessageSentAt': currentTime,
    });
  }
}
