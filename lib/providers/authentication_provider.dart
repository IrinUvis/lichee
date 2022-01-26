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

  Stream<QuerySnapshot<Map<String, dynamic>>> userDataStream() {
    if (currentUser != null) {
      return _firestore
          .collection('users')
          .where('id', isEqualTo: currentUser!.uid)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Future<UserData> getCurrentUserData() async {
    final usersWithId = await _firestore
        .collection('users')
        .where('id', isEqualTo: currentUser!.uid)
        .get();
    final user = UserData.mapToUserInfo(usersWithId.docs[0].data());
    return user;
  }

  Future<UserCredential> signUp({
    required UserData userData,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData.email!, password: password);
    await _firestore.collection('users').doc(userData.id).set(
          userData
              .copyWith(
                id: userCredential.user!.uid,
              )
              .toMap(),
        );
    await userCredential.user!.updateDisplayName(userData.username);
    await signIn(email: userData.email!, password: password);
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
