import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
// import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:test_agora/src/model/doctor.dart';
import 'package:test_agora/src/model/calendar_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_agora/src/model/reply.dart';
import 'package:test_agora/src/model/messenger.dart';

// import 'package:cmms/src/model/thietbi.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// final orpc = OdooClient('http://27.71.25.107');

class AppData {
  const AppData._();
  static final _logger = Logger();
  static String? username;
  static String? password;
  static String? userID;
  static List<Doctor> doctorList = [];
  static List<CalendarEvent> calendareventList = [];
  static List<Reply> replyList = [];
  static List<Messenger> messengerList = [];

  static Future<void> fetchDataMessengerFromApi() async {
    var username = 'nammta@gmail.com';
    var password = '123456';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    const apiUrl =
        'http://27.71.25.107/api/v1/search_read/hospital.messenger?db=doctor&with_context={}&with_company=1&fields=["patient_name","messenger_date","note","doctor_id","message_reply_ids","company_id","dob","phone"]';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      _logger.i('response.statusCode: ${response.statusCode}');
      var res = json.decode(response.body);

      messengerList = (res as List).map((e) => Messenger.fromJson(e)).toList();

      _logger.i('messegen data from API: $messengerList');
    } else {
      throw Exception('Failed to load data from API');
    }

    const apiUrl1 =
        'http://27.71.25.107/api/v1/search_read/hospital.messenger.reply?db=doctor&with_context={}&with_company=1&fields=["reply_text","original_message_id","replied_by","reply_date","message"]';

    final response_1 = await http.get(
      Uri.parse(apiUrl1),
      headers: headers,
    );

    if (response_1.statusCode == 200) {
      _logger.i('response_hr.statusCode: ${response_1.statusCode}');
      var res_reply = json.decode(response_1.body);

      replyList = (res_reply as List).map((e) => Reply.fromJson(e)).toList();

      _logger.i('replyList data from API: $replyList');
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  static Future<void> fetchDataDoctorFromApi() async {
    var username = 'nammta@gmail.com';
    var password = '123456';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    const apiUrl =
        'http://27.71.25.107/api/v1/search_read/calendar.event?db=doctor&with_context={}&with_company=1&fields=["create_uid","display_name","duration","display_time","user_id"]';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      _logger.i('response.statusCode: ${response.statusCode}');
      var myList = json.decode(response.body);

      calendareventList =
          (myList as List).map((e) => CalendarEvent.fromJson(e)).toList();

      _logger.i('calendareventList data from API: $calendareventList');
    } else {
      throw Exception('Failed to load data from API');
    }

    const hr_employee =
        'http://27.71.25.107/api/v1/search_read/hr.employee?db=doctor&with_context={}&with_company=1&fields=["is_doctor","display_name","certificate","degrees","job_title","study_field","study_school","consultancy_charge","im_status","consultancy","specialization","appID","token","channel","company_id"]';

    final response_hr = await http.get(
      Uri.parse(hr_employee),
      headers: headers,
    );

    if (response_hr.statusCode == 200) {
      _logger.i('response_hr.statusCode: ${response_hr.statusCode}');
      var res_doctor = json.decode(response_hr.body);

      doctorList = (res_doctor as List).map((e) => Doctor.fromJson(e)).toList();
      doctorList =
          doctorList.where((doctor) => doctor.is_doctor == 'doctor').toList();

      _logger.i('doctorList data from API: $doctorList');
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
