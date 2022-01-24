import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/read/read_channel_service.dart';

class ChannelListController {
  final FirebaseFirestore firestore;
  late final ReadChannelService readChannelService;

  ChannelListController({required this.firestore}) {
    readChannelService = ReadChannelService(firestore: firestore);
  }

  Future<void> getCitiesFromChannels({required List<String> citiesList}) async {
    await firestore.collection('channels').get().then((querySnapshot) => {
          for (var element in querySnapshot.docs)
            {
              if (!citiesList.contains(element.get('city')))
                {citiesList.add(element.get('city'))}
            }
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoriesStream({
    required String parentId,
  }) {
    return firestore
        .collection('categories')
        .where('parentId', isEqualTo: parentId)
        .snapshots();
  }

  Future<void> getChannelsFromCity(List<String>? selectedFiltersList,
      List<String> idsOfChannelsFromCity) async {
    await firestore.collection('channels').get().then((querySnapshot) => {
          for (var element in querySnapshot.docs)
            {
              if (selectedFiltersList!.isNotEmpty &&
                  element.get('city') == selectedFiltersList.first)
                {idsOfChannelsFromCity.add(element.id)}
            }
        });
  }

  Future<ReadChannelDto> getChannelById({required String channelId}) {
    return readChannelService.getById(id: channelId);
  }
}
