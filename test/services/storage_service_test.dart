import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichee/services/storage_service.dart';

import '../setup/storage_mock_setup/firebase_storage_mocks_base.dart';

void main() {
  final _fakeStorage = MockFirebaseStorage();
  final _storageService = StorageService(_fakeStorage);

  group('Storage services', () {
    test('file uploads work correctly', () async {
      final file = File('test/test_resources/test_file.txt');
      const path = '/some-path';
      final downloadUrl =
          await _storageService.uploadFile(path: path, file: file);
      expect('test contents', await file.readAsString()) ;
      expect('some-path', _fakeStorage.ref(path).name);
      expect('gs://some-bucket/some-path', _fakeStorage.ref(path).fullPath);
      expect('some downloadUrl', downloadUrl);
    });
  });
}
