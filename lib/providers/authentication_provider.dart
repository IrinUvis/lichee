import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/screens/auth/role.dart';

class AuthenticationProvider {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthenticationProvider({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  Stream<User?> get authState => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserData> getCurrentUserData() async {
    if (currentUser != null) {
      final usersWithId = await _firestore
          .collection('users')
          .where('id', isEqualTo: currentUser!.uid)
          .get();
      final user = UserData.mapToUserInfo(usersWithId.docs[0].data());
      print('USERNAME: ' + user.username!);
      return user;
    } else {
      return UserData(
          id: 'undefined',
          username: 'undefined',
          email: 'undefined',
          dateOfBirth: null,
          role: Role.undefined,
          photoUrl: 'undefined');
    }
  }

  Future<UserCredential> signUp({
    required UserData userData,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData.email!, password: password);
    await userCredential.user!.updateDisplayName(userData.username);
    await signIn(email: userData.email!, password: password);
    _firestore.collection('users').doc(userData.id).set(
          userData
              .copyWith(
                id: userCredential.user!.uid,
              )
              .toMap(),
        );
    print(userCredential.user?.displayName);
    return userCredential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
