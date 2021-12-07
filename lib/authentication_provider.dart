import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lichee/screens/auth/user_data.dart';

class AuthenticationProvider {
  final FirebaseAuth _firebaseAuth;

  AuthenticationProvider(this._firebaseAuth);

  Stream<User?> get authState => _firebaseAuth.idTokenChanges();

  Future<void> signUp({
    required UserData userData,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email, password: password);
    FirebaseFirestore.instance.collection('users').add(
          userData
              .copyWith(
                id: userCredential.user!.uid,
              )
              .toMap(),
        );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}