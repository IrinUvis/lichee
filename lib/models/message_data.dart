import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {
  final String idSentBy;
  final String nameSentBy;
  final String messageText;
  final String? imageUrl;
  final DateTime sentAt;

  MessageData({
    required this.idSentBy,
    required this.nameSentBy,
    required this.messageText,
    this.imageUrl,
    required this.sentAt,
  });

  MessageData copyWith({
    String? idSentBy,
    String? nameSentBy,
    String? messageText,
    String? imageUrl,
    DateTime? sentAt,
  }) {
    return MessageData(
      idSentBy: idSentBy ?? this.idSentBy,
      nameSentBy: nameSentBy ?? this.nameSentBy,
      messageText: messageText ?? this.messageText,
      imageUrl: imageUrl ?? this.imageUrl,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  static MessageData mapToMessageData(Map<String, dynamic> map) {
    Timestamp sentAt = map['sentAt'];
    MessageData messageData = MessageData(
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
