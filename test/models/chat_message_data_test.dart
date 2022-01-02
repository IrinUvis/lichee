import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/chat_message_data.dart';

void main() {
  group('MessageData', () {
    test('copyWith method works well', () {
      final original = ChatMessageData(
        idSentBy: 'id',
        nameSentBy: 'name',
        messageText: 'messageText',
        imageUrl: null,
        sentAt: DateTime(2000),
      );

      final copiedWith = original.copyWith(
        idSentBy: 'new id',
        nameSentBy: 'new name',
        messageText: 'new messageText',
        imageUrl: 'new imageUrl',
        sentAt: DateTime(2020),
      );

      final copiedWithAgain = copiedWith.copyWith();

      expect('id', equals(original.idSentBy));
      expect('name', equals(original.nameSentBy));
      expect('messageText', equals(original.messageText));
      expect(null, equals(original.imageUrl));
      expect(DateTime(2000), equals(original.sentAt));

      expect('new id', equals(copiedWith.idSentBy));
      expect('new name', equals(copiedWith.nameSentBy));
      expect('new messageText', equals(copiedWith.messageText));
      expect('new imageUrl', equals(copiedWith.imageUrl));
      expect(DateTime(2020), equals(copiedWith.sentAt));

      expect('new id', equals(copiedWithAgain.idSentBy));
      expect('new name', equals(copiedWithAgain.nameSentBy));
      expect('new messageText', equals(copiedWithAgain.messageText));
      expect('new imageUrl', equals(copiedWithAgain.imageUrl));
      expect(DateTime(2020), equals(copiedWithAgain.sentAt));
    });

    test('mapToChatMessageData method works well', () {
      final map = {
        'idSentBy': 'id',
        'nameSentBy': 'name',
        'messageText': 'messageText',
        'sentAt': Timestamp.fromDate(DateTime(2000)),
      };

      final chatMessageData = ChatMessageData.mapToChatMessageData(map);

      expect('id', equals(chatMessageData.idSentBy));
      expect('name', equals(chatMessageData.nameSentBy));
      expect('messageText', equals(chatMessageData.messageText));
      expect(null, equals(chatMessageData.imageUrl));
      expect(DateTime(2000), equals(chatMessageData.sentAt));
    });

    test('toMap method works well', () {
      final chatMessageData = ChatMessageData(
        idSentBy: 'id',
        nameSentBy: 'name',
        messageText: 'messageText',
        imageUrl: null,
        sentAt: DateTime(2000),
      );

      final map = chatMessageData.toMap();

      expect('id', equals(map['idSentBy']));
      expect('name', equals(map['nameSentBy']));
      expect('messageText', equals(map['messageText']));
      expect(null, equals(map['imageUrl']));
      expect(DateTime(2000), equals(map['sentAt']));
    });
  });
}
