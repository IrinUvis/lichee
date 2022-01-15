import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventController {
  final FirebaseFirestore _firestore;

  AddEventController(this._firestore);

  Future<void> addEvent(
      {required String title,
      required String localization,
      required DateTime date,
      required List<String> interestedUsers,
      required List<String> goingUsers,
      required String channelId}) async {
    await _firestore
        .collection('events')
        .doc(channelId)
        .collection('events')
        .add({
      'title': title,
      'localization': localization,
      'date': date,
      'interestedUsers': interestedUsers,
      'goingUsers': goingUsers,
    });
  }
}
