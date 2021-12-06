import 'package:lichee/channels/services/read/read_channel_dto.dart';

class Channel {
  String? channelName;
  String? channelId;
  String? ownerId;
  List<String>? userIds;
  String? description;
  String? channelImageURL;
  DateTime? createdOn;
  String? city;

  Channel(
      {this.channelId,
      this.channelName,
      this.ownerId,
      this.userIds,
      this.description,
      this.channelImageURL,
      this.createdOn,
      this.city});

  ReadChannelDto toDto() {
    return ReadChannelDto(
      channelId: channelId!,
      channelName: channelName!,
      ownerId: ownerId!,
      userIds: userIds!,
      description: description!,
      channelImageURL: channelImageURL!,
      createdOn: createdOn!,
      city: city!,
    );
  }
}
