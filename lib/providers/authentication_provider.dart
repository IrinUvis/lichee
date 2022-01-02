import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lichee/models/user_data.dart';

class AuthenticationProvider {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthenticationProvider(this._firebaseAuth, this._firebaseFirestore);

  Stream<User?> get authState => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signUp({
    required UserData userData,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email!, password: password);
    await userCredential.user!.updateDisplayName(userData.username);
    await signIn(email: userData.email!, password: password);
    _firebaseFirestore.collection('users').add(
          userData
              .copyWith(
                id: userCredential.user!.uid,
              )
              .toMap(),
        );
    return userCredential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
