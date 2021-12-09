import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
  final String username;
  final String email;
  final String photoUrl;
  final DateTime dateOfBirth;

  UserData({
    this.id,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.dateOfBirth,
  });

  UserData copyWith({
    String? id,
    String? username,
    String? email,
    String? photoUrl,
    DateTime? dateOfBirth,
  }) {
    return UserData(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  static UserData mapToUserInfo(Map<String, dynamic> map) {
    Timestamp dob = map['dateOfBirth'];
    UserData userInfo = UserData(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      dateOfBirth: dob.toDate(),
    );
    return userInfo;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'dateOfBirth': dateOfBirth,
    };
  }
}
