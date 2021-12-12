import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  static Future<String> uploadFile({
    required String path,
    required File file,
  }) async {
    final task = FirebaseStorage.instance.ref(path).putFile(file);
    final snap = await task.whenComplete(() {});
    return snap.ref.getDownloadURL();
  }
}
