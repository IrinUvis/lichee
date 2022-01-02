import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelChatData implements Comparable<ChannelChatData> {
  final String channelId;
  final String channelName;
  final String channelNameLower;
  final String photoUrl;
  final String? recentMessageSentBy;
  final DateTime? recentMessageSentAt;
  final String? recentMessageText;
  final List<String> userIds;

  // TODO: Use it where applicable, (probably adding channels)
  ChannelChatData({
    required this.channelId,
    required this.channelName,
    required this.photoUrl,
    this.recentMessageSentBy,
    this.recentMessageSentAt,
    this.recentMessageText,
    required this.userIds,
  }) : channelNameLower = channelName.toLowerCase();

  ChannelChatData._({
    required this.channelId,
    required this.channelName,
    required this.channelNameLower,
    required this.photoUrl,
    this.recentMessageSentBy,
    this.recentMessageSentAt,
    this.recentMessageText,
    required this.userIds,
  });

  ChannelChatData copyWith({
    String? channelId,
    String? channelName,
    String? photoUrl,
    String? recentMessageSentBy,
    DateTime? recentMessageSentAt,
    String? recentMessageText,
    List<String>? userIds,
  }) {
    return ChannelChatData._(
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      channelNameLower:
          channelName != null ? channelName.toLowerCase() : channelNameLower,
      photoUrl: photoUrl ?? this.photoUrl,
      recentMessageSentBy: recentMessageSentBy ?? this.recentMessageSentBy,
      recentMessageSentAt: recentMessageSentAt ?? this.recentMessageSentAt,
      recentMessageText: recentMessageText ?? this.recentMessageText,
      userIds: userIds ?? this.userIds,
    );
  }

  static ChannelChatData mapToChannelChatData(Map<String, dynamic> map) {
    Timestamp? recentMessageSentAt = map['recentMessageSentAt'];
    return ChannelChatData(
      channelId: map['channelId'],
      channelName: map['channelName'],
      photoUrl: map['photoUrl'],
      recentMessageSentBy: map['recentMessageSentBy'],
      recentMessageSentAt: recentMessageSentAt?.toDate(),
      recentMessageText: map['recentMessageText'],
      userIds: List.from(map['userIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channelId': channelId,
      'channelName': channelName,
      'channelNameLower': channelNameLower,
      'photoUrl': photoUrl,
      'recentMessageSentBy': recentMessageSentBy,
      'recentMessageSentAt': recentMessageSentAt,
      'recentMessageText': recentMessageText,
      'userIds': userIds,
    };
  }

  @override
  int compareTo(ChannelChatData other) {
    final DateTime? chat1SentAt = recentMessageSentAt;
    final DateTime? chat2SentAt = other.recentMessageSentAt;
    if (chat1SentAt == null || chat2SentAt == null) {
      return 0;
    }
    return chat1SentAt.compareTo(chat2SentAt);
  }
}
