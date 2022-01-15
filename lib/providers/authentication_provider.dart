import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lichee/models/user_data.dart';

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
