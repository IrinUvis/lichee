import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/read/read_channel_service.dart';

class HomeScreenController {
  final ReadChannelService _readChannelService;

  HomeScreenController(FirebaseFirestore _firestore)
      : _readChannelService = ReadChannelService(firestore: _firestore);

  Future<List<ReadChannelDto>> getPromotedChannels() {
    return _readChannelService.getPromoted();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChannelsOfUserWithIdStream({
    required String userId,
  }) {
    return _readChannelService.getChannelsOfUserWithIdStream(userId);
  }
}
