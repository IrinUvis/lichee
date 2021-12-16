class Event {
  final String localization;
  final String title;
  final DateTime date;
  List<String> interestedUsers;
  List<String> goingUsers;

  Event(
      {required this.localization,
      required this.title,
      required this.date,
      required this.interestedUsers,
      required this.goingUsers});


}
