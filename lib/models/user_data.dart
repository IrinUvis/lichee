import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/screens/auth/role.dart';

class UserData {
  final String? id;
  final String? username;
  final String? email;
  final String? photoUrl;
  final Role? role;
  final DateTime? dateOfBirth;

  UserData({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.role,
    this.dateOfBirth,
  });

  UserData copyWith({
    String? id,
    String? username,
    String? email,
    String? photoUrl,
    Role? role,
    DateTime? dateOfBirth,
  }) {
    return UserData(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  static UserData mapToUserInfo(Map<String, dynamic> map) {
    Timestamp dob = map['dateOfBirth'];
    String roleLiteral = map['role'];
    UserData userInfo = UserData(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      role: roleLiteral.toRole(),
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
      'role': role!.getName(),
      'dateOfBirth': dateOfBirth,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          photoUrl == other.photoUrl &&
          role == other.role &&
          dateOfBirth == other.dateOfBirth;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      photoUrl.hashCode ^
      role.hashCode ^
      dateOfBirth.hashCode;
}
