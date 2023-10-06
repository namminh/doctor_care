class Messenger {
  String id;
  String patient_name;
  String dob;
  String messenger_date;
  String gender;
  String patient_age;
  String phone;
  String note;
  String doctor_id;
  String message_reply_ids;
  String? company_id;
  Messenger({
    required this.id,
    required this.patient_name,
    required this.dob,
    required this.messenger_date,
    required this.gender,
    required this.patient_age,
    required this.phone,
    required this.doctor_id,
    required this.note,
    required this.message_reply_ids,
    this.company_id,
  });

  factory Messenger.fromJson(Map<String, dynamic> json) {
    return Messenger(
      patient_name: json['patient_name'].toString(),
      dob: json['dob'].toString(),
      messenger_date: json['messenger_date'].toString(),
      gender: json['gender'].toString(),
      patient_age: json['patient_age'].toString(),
      phone: json['phone'].toString(),
      id: json['id'].toString(),
      doctor_id: json['doctor_id'].toString(),
      note: json['note'].toString(),
      message_reply_ids: json['message_reply_ids'].toString(),
      company_id: json['company_id'].toString(),
    );
  }
}
