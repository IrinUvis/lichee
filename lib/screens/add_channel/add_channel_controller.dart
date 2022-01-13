import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:lichee/services/storage_service.dart';

class AddChannelController {
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  AddChannelController(this._firestore, this._storage);

  Future<String> uploadPhoto({
    required String uuid,
    required DateTime currentTime,
    required File file,
  }) async {
    return await _storage.uploadFile(
        path: 'channels/' +
            uuid +
            '-' +
            currentTime.millisecondsSinceEpoch.toString(),
        file: file);
  }

}
