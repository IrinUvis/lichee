import 'package:cloud_firestore/cloud_firestore.dart';

class ReadChannelDto {
  final String _channelName;
  final String _channelId;
  final String _ownerId;
  List<String> _userIds = [];
  String _description;
  final String _channelImageURL;
  final DateTime _createdOn;
  final String _city;
  final bool _isPromoted;

  ReadChannelDto({
    required channelId,
    required channelName,
    required ownerId,
    userIds,
    description,
    required channelImageURL,
    required createdOn,
    required city,
    required isPromoted,
  })  : _channelId = channelId,
        _channelName = channelName,
        _ownerId = ownerId,
        _userIds = userIds,
        _description = description,
        _channelImageURL = channelImageURL,
        _createdOn = createdOn,
        _city = city,
        _isPromoted = isPromoted;

  String get channelId => _channelId;

  String get ownerId => _ownerId;

  String get channelName => _channelName;

  List<String> get userIds => _userIds;

  String get description => _description;

  String get channelImageUrl => _channelImageURL;

  DateTime get createdOn => _createdOn;

  String get city => _city;

  bool get isPromoted => _isPromoted;
}
