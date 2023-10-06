class CalendarEvent {
  String id;
  String create_uid;
  String display_name;
  String display_time;
  String user_id;
  double? duration;

  CalendarEvent({
    required this.id,
    required this.create_uid,
    required this.display_name,
    required this.display_time,
    required this.user_id,
    required this.duration,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      create_uid: json['create_uid'].toString(),
      // companyId: json['company_id'],
      // currencyId: json['currency_id'].cast<int>(),
      display_name: json['display_name'].toString(),
      // description: json['description'],
      id: json['id'].toString(),
      display_time: json['display_time'].toString(),
      user_id: json['user_id'].toString(),

      duration: json['duration'],
    );
  }
}
