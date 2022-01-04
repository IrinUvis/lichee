import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListController {
  final FirebaseFirestore _firestore;

  ChatListController(this._firestore);

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatsStream({
    required String query,
    required String userId,
  }) {
    return _firestore
        .collection('channel_chats')
        .where('channelNameLower',
            isGreaterThanOrEqualTo: query.toLowerCase().trim())
        .where('channelNameLower',
            isLessThanOrEqualTo: query.toLowerCase().trim() + '~')
        .where('userIds', arrayContains: userId)
        .snapshots();
  }
}
