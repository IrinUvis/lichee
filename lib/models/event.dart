class Event {
  final String localization;
  final String title;
  final DateTime date;
  List<String> interestedUsers;
  List<String> goingUsers;
  final String channelId;

  Event(
      {required this.localization,
      required this.title,
      required this.date,
      required this.interestedUsers,
      required this.goingUsers,
      required this.channelId});

  Map<String, dynamic> toMap() {
    return {
      'localization': localization,
      'title': title,
      'date': date,
      'interestedUsers': interestedUsers,
      'goingUsers': goingUsers,
      'channelId': channelId,
    };
  }

}
