import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/providers/authentication_provider.dart';

import '../auth_mock_setup/firebase_auth_mocks_base.dart';
import '../auth_mock_setup/mock_user.dart';
import '../auth_mock_setup/mock_user_credential.dart';

class FakeFirebaseAuth extends MockFirebaseAuth {
  FakeFirebaseAuth({signedIn = false, MockUser? mockUser})
      : super(signedIn: signedIn, mockUser: mockUser);

  @override
  Future<MockUserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    super.signInWithEmailAndPassword(email: email, password: password);
    return MockUserCredential(
      false,
      mockUser: MockUser(
          isAnonymous: false,
          uid: 'some uid',
          email: 'some email',
          displayName: 'some displayName'),
    );
  }
}

void main() {
  const uid = 'some uid';
  const email = 'some email';
  const displayName = 'some displayName';
  const photoUrl = 'some photoUrl';
  const password = 'some password';
  final dateOfBirth = DateTime(2020);
  final user = MockUser(
      isAnonymous: false, uid: uid, email: email, displayName: displayName);

  final FakeFirebaseAuth _fakeAuth =
      FakeFirebaseAuth(signedIn: false, mockUser: user);
  final FakeFirebaseFirestore _fakeFirestore = FakeFirebaseFirestore();
  final _authProvider = AuthenticationProvider(_fakeAuth, _fakeFirestore);

  group('Authentication services', () {
    setUp(() async {
      _fakeAuth.signOut();
    });

    test('Signing up works correctly', () async {
      expect(null, _fakeAuth.currentUser);
      await _authProvider.signUp(
        userData: UserData(
          username: displayName,
          email: email,
          photoUrl: photoUrl,
          dateOfBirth: dateOfBirth,
        ),
        password: password,
      );
      expect(user, _fakeAuth.currentUser);
      final querySnap = await _fakeFirestore.collection('users').get();
      final userData = UserData.mapToUserInfo(querySnap.docs.first.data());
      expect(uid, userData.id);
      expect(email, userData.email);
      expect(displayName, userData.username);
      expect(photoUrl, userData.photoUrl);
      expect(dateOfBirth, userData.dateOfBirth);
    });

    test('Signing in works correctly', () {
      expect(null, _fakeAuth.currentUser);
      _authProvider.signIn(
        email: email,
        password: password,
      );
      expect(user, _fakeAuth.currentUser);
    });

    test('Signing out works correctly', () {
      expect(null, _fakeAuth.currentUser);
      _authProvider.signIn(
        email: email,
        password: password,
      );
      expect(user, _fakeAuth.currentUser);
      _authProvider.signOut();
      expect(null, _fakeAuth.currentUser);
    });
  });
}
