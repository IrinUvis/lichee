import 'package:lichee/channels/domain/channels_repository.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';

class ReadChannelService {
  final _repository = ChannelRepository();

  Future<ReadChannelDto> getById({required String id}) async {
      final channel = await _repository.getById(id: id);
      return channel.toDto();
  }

  Future<List<ReadChannelDto>> getByName({required String name}) async {
    final channels = await _repository.getByName(name: name);
    return channels.map((channel) => channel.toDto()).toList();
  }

  Future<List<ReadChannelDto>> getByCity({required String city}) async {
    final channels = await _repository.getByCity(city: city);
    return channels.map((e) => e.toDto()).toList();
  }

  Future<List<ReadChannelDto>> getAll() async {
    final channels = await _repository.getAllChannels();
    return channels.map((channel) => channel.toDto()).toList();
  }

  Future<List<ReadChannelDto>> getByOwner({required String owner}) async {
    final channels = await _repository.getByName(name: owner);
    return channels.map((channel) => channel.toDto()).toList();
  }

}
