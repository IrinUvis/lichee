import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/user_data.dart';

void main() {
  group('UserData', () {
    test('copyWith method works well', () {
      final original = UserData(
        id: 'id',
        email: 'email',
        username: 'username',
        photoUrl: 'photoUrl',
        dateOfBirth: DateTime(2000),
      );

      final copiedWith = original.copyWith(
        id: 'new id',
        email: 'new email',
        username: 'new username',
        photoUrl: 'new photoUrl',
        dateOfBirth: DateTime(2020),
      );

      final copiedWithAgain = copiedWith.copyWith();

      expect('id', equals(original.id));
      expect('email', equals(original.email));
      expect('username', equals(original.username));
      expect('photoUrl', equals(original.photoUrl));
      expect(DateTime(2000), equals(original.dateOfBirth));

      expect('new id', equals(copiedWith.id));
      expect('new email', equals(copiedWith.email));
      expect('new username', equals(copiedWith.username));
      expect('new photoUrl', equals(copiedWith.photoUrl));
      expect(DateTime(2020), equals(copiedWith.dateOfBirth));

      expect('new id', equals(copiedWithAgain.id));
      expect('new email', equals(copiedWithAgain.email));
      expect('new username', equals(copiedWithAgain.username));
      expect('new photoUrl', equals(copiedWithAgain.photoUrl));
      expect(DateTime(2020), equals(copiedWithAgain.dateOfBirth));
    });

    test('mapToUserData method works well', () {
      final map = {
        'id': 'id',
        'email': 'email',
        'username': 'username',
        'dateOfBirth': Timestamp.fromDate(DateTime(2000)),
      };

      final userData = UserData.mapToUserInfo(map);

      expect('id', equals(userData.id));
      expect('email', equals(userData.email));
      expect('username', equals(userData.username));
      expect(null, equals(userData.photoUrl));
      expect(DateTime(2000), equals(userData.dateOfBirth));
    });

    test('toMap method works well', () {
      final userData = UserData(
          username: 'username', email: 'email', dateOfBirth: DateTime(2000));

      final map = userData.toMap();

      expect(null, equals(map['id']));
      expect('email', equals(map['email']));
      expect('username', equals(map['username']));
      expect(null, equals(map['photoUrl']));
      expect(DateTime(2000), equals(map['dateOfBirth']));
    });
  });
}
