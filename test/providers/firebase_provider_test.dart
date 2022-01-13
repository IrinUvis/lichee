import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/services/storage_service.dart';

import '../setup/storage_mock_setup/firebase_storage_mocks_base.dart';
import 'authentication_provider_test.dart';

void main() {
  group('FirebaseProvider', () {
    test('getters work fine', () {
      final _auth = FakeFirebaseAuth();
      final _firestore = FakeFirebaseFirestore();
      final _storage = StorageService(MockFirebaseStorage());

      final provider = FirebaseProvider(
        auth: _auth,
        firestore: _firestore,
        storage: _storage,
      );

      expect(provider.auth, isNotNull);
      expect(provider.firestore, isNotNull);
      expect(provider.storage, isNotNull);
    });
  });
}
