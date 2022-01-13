import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lichee/services/storage_service.dart';

class FirebaseProvider {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  FirebaseAuth get auth => _auth;

  FirebaseFirestore get firestore => _firestore;

  StorageService get storage => _storage;

  FirebaseProvider({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required StorageService storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;
}
