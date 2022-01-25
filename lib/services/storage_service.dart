import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<String> uploadFile({
    required String path,
    required File file,
  }) async {
    final task = _storage.ref(path).putFile(file);
    final snap = await task.whenComplete(() {});
    return snap.ref.getDownloadURL();
  }
}
