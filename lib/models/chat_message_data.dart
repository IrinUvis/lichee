import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageData {
  final String idSentBy;
  final String nameSentBy;
  final String messageText;
  final String? imageUrl;
  final DateTime sentAt;

  ChatMessageData({
    required this.idSentBy,
    required this.nameSentBy,
    required this.messageText,
    required this.imageUrl,
    required this.sentAt,
  });

  ChatMessageData copyWith({
    String? idSentBy,
    String? nameSentBy,
    String? messageText,
    String? imageUrl,
    DateTime? sentAt,
  }) {
    return ChatMessageData(
      idSentBy: idSentBy ?? this.idSentBy,
      nameSentBy: nameSentBy ?? this.nameSentBy,
      messageText: messageText ?? this.messageText,
      imageUrl: imageUrl ?? this.imageUrl,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  static ChatMessageData mapToChatMessageData(Map<String, dynamic> map) {
    Timestamp sentAt = map['sentAt'];
    ChatMessageData messageData = ChatMessageData(
      idSentBy: map['idSentBy'],
      nameSentBy: map['nameSentBy'],
      messageText: map['messageText'],
      imageUrl: map['imageUrl'],
      sentAt: sentAt.toDate(),
    );
    return messageData;
  }

  Map<String, dynamic> toMap() {
    return {
      'idSentBy': idSentBy,
      'nameSentBy': nameSentBy,
      'messageText': messageText,
      'imageUrl': imageUrl,
      'sentAt': sentAt,
    };
  }
}
