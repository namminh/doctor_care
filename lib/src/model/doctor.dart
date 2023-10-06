class Doctor {
  String id;
  String title;
  String specialist;
  String specialization;
  String certificate;
  String description;
  String degrees;
  String is_doctor;
  String im_status;
  String consultancy;
  String company_id;
  String user_id;
  String? study_school;
  String? appID;
  String? token;
  String? channel;
  int patient;
  int experiences;
  int? price;
  int quantity;
  double score;
  // String images;
  bool isFavorite;

  // List<CalendarEvent> calendar;

  Doctor({
    required this.id,
    required this.title,
    required this.specialist,
    required this.specialization,
    required this.certificate,
    required this.description,
    required this.degrees,
    required this.is_doctor,
    required this.im_status,
    required this.consultancy,
    required this.patient,
    required this.experiences,
    required this.price,
    required this.company_id,
    required this.user_id,
    this.study_school,
    this.appID,
    this.token,
    this.channel,
    this.quantity = 1,
    required this.score,
    // required this.images,
    this.isFavorite = false,
    // required this.calendar,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      title: json['display_name'].toString(),
      // companyId: json['company_id'],
      // currencyId: json['currency_id'].cast<int>(),
      certificate: json['certificate'].toString(),
      // description: json['description'],
      id: json['id'].toString(),
      degrees: json['degrees'].toString(),
      is_doctor: json['is_doctor'].toString(),
      im_status: json['im_status'].toString(),
      consultancy: json['consultancy'].toString(),
      // // locationId: json['location_id'],
      description: json['job_title'].toString(),
      specialist: json['study_field'].toString(),
      study_school: json['study_school'].toString(),
      user_id: json['user_id'].toString(),
      specialization: json['specialization'].toString(),
      appID: json['appID'].toString(),
      token: json['token'].toString(),
      channel: json['channel'].toString(),
      // images: json['image_url'].toString(),

      price: json['consultancy_charge'].toInt(),
      company_id: json['company_id'].toString(),
      score: 3.5,
      patient: 100,
      experiences: 7,

      // colors: <FurnitureColor>[
      //   FurnitureColor(color: const Color(0xFF455a64), isSelected: true),
      //   FurnitureColor(color: const Color(0xFF263238)),
      // ],
    );
  }
}
