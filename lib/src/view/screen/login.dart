import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_agora/core/app_data.dart';
import 'package:test_agora/src/view/screen/agora_screen.dart';
import 'package:test_agora/src/view/screen/agora_uikit.dart';
import 'package:test_agora/src/view/screen/doctor_detail_screen.dart';

import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_agora/src/model/doctor.dart';
import 'package:test_agora/src/model/calendar_event.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? username;
  String? password;
  String? userID;
  String? name;
  String? temp;
  int check = 0;
  final double height = window.physicalSize.height;
  TextEditingController _textControllerUser = TextEditingController();
  TextEditingController _textControllerPass = TextEditingController();
  static final _logger = Logger();
  bool isChecked = false;

  List<Doctor> _doctor = [];
  List<CalendarEvent> calendareventList = [];
  bool isLoading = false;
  bool isUserID = false;

  @override
  initState() {
    setState(() {});
    super.initState();

    _loadUsernameFromPreferences();
    _loadPassFromPreferences();

    // getdata();
  }

  // Future<void> remove() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove('username');
  //   prefs.remove('password');
  //   prefs.remove('name');
  // }

  void saveUsername(
      String username, String password, String name, String userid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setString('name', name);
    await prefs.setString('user_id', userid);
    _logger.i('saveUsername:  $userid');
  }

  Future<void> _loadUsernameFromPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? tempUsername =
        preferences.getString('username') ?? 'nammta@gmail.com';
    if (tempUsername != null) {
      setState(() {
        username = tempUsername; // Gán giá trị vào biến username
        _textControllerUser.text = username ?? '';
      });
    }
  }

  Future<void> _loadPassFromPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? tempPassword = preferences.getString('password') ?? '123456';
    if (tempPassword != null) {
      setState(() {
        password = tempPassword; // Gán giá trị vào biến username
        isChecked = true;
        _textControllerPass.text = password ?? '';
      });
      checklogin(username ?? '', password ?? '');
    }
  }

  Future<void> checklogin(String username, String password) async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri = Uri.parse(
        "http://27.71.25.107/api/v1/session?db=doctor&with_context=%7B%7D");

    http.Response response = await http.get(_uri, headers: headers);

    dynamic result = json.decode(response.body);
    if (response.statusCode == 200) {
      String tempUsername = result["username"].toString();
      String tempName = result["name"].toString();
      String tempUserID = result["user_id"].toString();

      // Gán giá trị vào biến temp
      temp = tempUsername;
      name = tempName;
      userID = tempUserID;
      _logger.i('name:  $name');
    } else {
      _logger.i('error: $temp $name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login.png"),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textControllerUser,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _textControllerPass,
                        style: TextStyle(),
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onChanged: (value) {
                          // Gọi hàm checklogin khi người dùng thay đổi giá trị trong ô nhập liệu
                          username = _textControllerUser.text;
                          password = _textControllerPass.text;
                          checklogin(username ?? '', password ?? '');
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Nhớ tôi",
                            style: TextStyle(color: Colors.black),
                          ),
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              isChecked = !isChecked;
                              checklogin(_textControllerUser.text,
                                  _textControllerPass.text);

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.w700),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4c505b),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  _logger.i(' data from API:  ${name}');
                                  _logger.i(' _doctor:  ${_doctor}');
                                  if (username == temp) {
                                    _logger.i("username $username");

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorDetailScreen(
                                                    name: name ?? '')));

                                    saveUsername(username ?? '', password ?? '',
                                        name ?? '', userID ?? '');
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'Bạn nhập sai email/password',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_forward,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
