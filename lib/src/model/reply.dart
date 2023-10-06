class Reply {
  String id;
  String reply_text;
  String original_message_id;
  String replied_by;
  String reply_date;
  String message;

  String? company_id;
  Reply({
    required this.id,
    required this.reply_text,
    required this.original_message_id,
    required this.replied_by,
    required this.reply_date,
    required this.message,
    this.company_id,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      reply_text: json['reply_text'].toString(),
      original_message_id: json['original_message_id'].toString(),
      replied_by: json['replied_by'].toString(),
      reply_date: json['reply_date'].toString(),
      message: json['message'].toString(),
      id: json['id'].toString(),
      company_id: json['company_id'].toString(),
    );
  }
}
