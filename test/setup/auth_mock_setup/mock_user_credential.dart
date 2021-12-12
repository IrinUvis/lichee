import 'package:firebase_auth/firebase_auth.dart';

import 'mock_user.dart';

class MockUserCredential implements UserCredential {
  final bool _isAnonymous;
  final MockUser? _mockUser;

  MockUserCredential(bool isAnonymous, {MockUser? mockUser})
  // Ensure no mocked credentials or mocked for Anonymous
      : assert(mockUser == null || mockUser.isAnonymous == isAnonymous),
        _isAnonymous = isAnonymous,
        _mockUser = mockUser;

  @override
  User get user => _mockUser ?? MockUser(isAnonymous: _isAnonymous);

  @override
  AdditionalUserInfo? get additionalUserInfo => throw UnimplementedError();

  @override
  AuthCredential? get credential => throw UnimplementedError();
}