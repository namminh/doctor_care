import 'package:test_agora/core/app_asset.dart';
import 'package:test_agora/src/model/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:test_agora/core/app_color.dart';
import 'package:test_agora/core/app_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_agora/core/app_extension.dart';
import 'package:test_agora/src/model/doctor.dart';
import 'package:test_agora/src/view/screen/agora_screen.dart';
import 'dart:convert';
import 'package:test_agora/src/model/reply.dart';
import 'package:http/http.dart' as http;

import 'package:test_agora/core/colors.dart';
import 'package:test_agora/core/styles.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:test_agora/core/app_data.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

//widgets
const appId = "3e5fa9beb897407fbee021af67a07449";

const appCertificate = '544750d742b74619b9507f563176f0cc';

final role = RtcRole.publisher;

final expirationInSeconds = 3600;
final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
final expireTimestamp = currentTimestamp + expirationInSeconds;

class DoctorDetailScreen extends StatefulWidget {
  final String name;
  const DoctorDetailScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  Iterable<Doctor> doctor = [];
  static final _logger = Logger();
  List<CalendarEvent> calendarList = [];
  List<Reply> replyList = [];
  @override
  void initState() {
    super.initState();
    doctor = AppData.doctorList.where(
        (element) => element.title.toString().contains(widget.name ?? ''));
    boloc();
    bolocReply();
    // gán giá trị của thietbi được truyền từ màn hình trước
  }

  boloc() {
    List<CalendarEvent> temp = AppData.calendareventList
        .where((calendar) =>
            calendar.create_uid.toString().contains(doctor.single.title))
        .toList();

    DateTime currentDate = DateTime.now();
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    if (temp.length > 0) {
      for (var calendar in temp) {
        final eventDate = dateFormat.parse(calendar.display_time.split(' ')[0]);

        _logger.i("eventDate: ${eventDate.isAtSameMomentAs(currentDate)}");
        _logger.i("currentDate: ${currentDate}");

        if (eventDate.isAtSameMomentAs(currentDate) ||
            eventDate.isAfter(currentDate)) {
          _logger.i("calendar: ${calendar}");
          calendarList.add(calendar);
        }
      }
    }
  }

  Future<void> updateDoctorFromApi(
      String id, String token, String username, String password) async {
    try {
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      var headers = {
        "Accept": "application/json",
        "Authorization": basicAuth,
      };
      Uri _uri = Uri.parse(
          'http://27.71.25.107/api/v1/write/hr.employee?db=doctor&ids=["$id"]&values={ "token": "$token"}&with_context={}&with_company=1');

      http.Response response = await http.put(_uri, headers: headers);
      _logger.i('test ${_uri}');
      if (response.statusCode == 200) {
        _logger.i('_uri');
        Fluttertoast.showToast(
          msg: 'Đã thêm thành công token',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      _logger.i(error);
    }
  }

  String khoitao() {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int expireTimestamp = currentTimestamp + expirationInSeconds;
    _logger.i('channelName: ${doctor.single.channel}');
    final token = RtcTokenBuilder.build(
      appId: appId,
      appCertificate: appCertificate,
      channelName: doctor.single.channel ?? '',
      uid: '0',
      role: role,
      expireTimestamp: expireTimestamp,
    );

    return token;
  }

  bolocReply() {
    replyList = AppData.replyList
        .where((temp) => temp.replied_by
            .toString()
            .toLowerCase()
            .contains(doctor.single.title.toLowerCase()))
        .toList();
  }

  Widget buildStatusIcon(Doctor doctor) {
    IconData iconData;
    Color iconColor;

    if (doctor.im_status == 'online') {
      iconData =
          Icons.online_prediction; // Thay thế bằng biểu tượng online thích hợp
      iconColor = Colors.green;
    } else {
      iconData =
          Icons.offline_pin; // Thay thế bằng biểu tượng offline thích hợp
      iconColor = Colors.grey;
    }

    return Icon(
      iconData,
      color: iconColor,
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(doctor.single.title ?? '', style: h2Style),
    );
  }

  Widget DateTimeCard(List<CalendarEvent> events) {
    if (events.length == 0) {
      // Return an empty or placeholder widget when events are null or empty
      return SizedBox.shrink();
    } else {
      return Container(
        height:
            120, // Adjust the height as needed or use Expanded for flexible height
        child: ListView.builder(
          reverse: true,
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final displayTimeParts = event.display_time.split(' ');

            return Container(
              decoration: BoxDecoration(
                color: Color(MyColors.bg03),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.note,
                        color: Color(MyColors.primary),
                        size: 17,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Nội dung: ${event.display_name}',
                        style: TextStyle(
                          color: Color(MyColors.primary),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Color(MyColors.primary),
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: '${displayTimeParts[0]}\n',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(MyColors.primary),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${displayTimeParts[2]}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(MyColors.header01),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' tới ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(MyColors.primary),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${displayTimeParts[4]}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(MyColors.header01),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' ${displayTimeParts[5]}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(MyColors.primary),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_alarm,
                        color: Color(MyColors.primary),
                        size: 17,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${event.duration} giờ',
                        style: TextStyle(
                          color: Color(MyColors.primary),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  Widget bottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlack,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              updateDoctorFromApi(
                  doctor.single.id, khoitao(), 'nammta@gmail.com', '123456');
            },

            // => controller.addToCart(doctor),
            child: const Text("Token"),
          )),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlack,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AgoraScreen(
                          doctor: doctor.single,
                          token: khoitao(),
                        )),
              );
            },
            // => controller.addToCart(doctor),
            child: const Text("call"),
          )),
        ],
      ),
    ).fadeAnimation(1.3);
  }

  Widget _listViewItem(Reply reply, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg03),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.subject,
                color: Color(MyColors.primary),
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              reply.replied_by == 'false'
                  ? SizedBox() // Nếu doctor.consultancy là false, không hiển thị gì cả
                  : Flexible(
                      child: Text(
                        reply.replied_by ?? '',
                        style: h4Style,
                      ).fadeAnimation(0.8),
                    ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Color(MyColors.primary),
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              reply.reply_date == 'false'
                  ? SizedBox() // Nếu doctor.consultancy là false, không hiển thị gì cả
                  : Text(
                      '${reply.reply_date}' ?? '',
                      style: h5Style.copyWith(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).fadeAnimation(1.4),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.question_answer,
                color: Color(MyColors.primary),
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              reply.message == 'false'
                  ? SizedBox() // Nếu doctor.consultancy là false, không hiển thị gì cả
                  : Flexible(
                      child: Text(
                        reply.message ?? '',
                        style: h4Style,
                      ).fadeAnimation(0.8),
                    ),
            ],
          ),
          Text(
            '-------------',
            style: h4Style,
          ).fadeAnimation(0.8),
          Row(
            children: [
              Icon(
                Icons.chat,
                color: Color(MyColors.primary),
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              reply.reply_text == 'false'
                  ? SizedBox() // Nếu doctor.consultancy là false, không hiển thị gì cả
                  : Flexible(
                      child: Text(
                        reply.reply_text ?? '',
                        style: h4Style,
                      ).fadeAnimation(0.8),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget NumberCard(String label, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(MyColors.bg03),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(MyColors.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value.toString(),
              style: TextStyle(
                color: Color(MyColors.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DetailBody() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailDoctorCard(),
          SizedBox(
            height: 15,
          ),

          DateTimeCard(calendarList),

          SizedBox(
            height: 15,
          ),
          Text(
            'Thông tin bác sĩ',
            style: kTitleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Quá trình đào tạo:',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w900,
              height: 2.5,
            ),
          ),
          Text(
            '${doctor.single.study_school}\n',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 2.5,
            ),
          ),
          Text(
            'Thế mạnh chuyên môn: ',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w900,
              height: 2.5,
            ),
          ),
          Text(
            '${doctor.single.specialist} \n',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 2.5,
            ),
          ),
          Text(
            'Nội dung trả lời: ',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w900,
              height: 2.5,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: const ClampingScrollPhysics(),
            itemCount: replyList.length,
            itemBuilder: (_, index) {
              Reply reply = replyList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 10),
                child: _listViewItem(reply, index),
              );
            },
          ),
          // SizedBox(
          //   height: 25,
          // ),
          // Row(
          //   children: [
          //     Expanded(child: SeviceSelect(_doctor.service)),
          //   ],
          // ).fadeAnimation(1.0),
        ],
      ),
    );
  }

  // Widget DoctorInfo() {
  //   return Row(
  //     children: [
  //       NumberCard(
  //         'Bệnh nhân',
  //         _doctor.patient.toString(),
  //       ),
  //       SizedBox(width: 15),
  //       NumberCard(
  //         'Kinh nghiệm',
  //         _doctor.experiences.toString(),
  //       ),
  //       SizedBox(width: 15),
  //       NumberCard(
  //         'Điểm',
  //         _doctor.score.toString(),
  //       ),
  //     ],
  //   );
  // }

  Widget DetailDoctorCard() {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        buildStatusIcon(doctor.single),
                        doctor.single.consultancy == 'false'
                            ? SizedBox() // Nếu doctor.consultancy là false, không hiển thị gì cả
                            : Text(
                                doctor.single.consultancy ?? '',
                                style: h4Style,
                              ).fadeAnimation(0.8),
                      ],
                    ),
                    Text(
                      doctor.single.title ?? '',
                      style: TextStyle(
                          color: Color(MyColors.header01),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Chuyên khoa: ${doctor.single.specialist}',
                      style: TextStyle(
                        color: Color(MyColors.grey02),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Đơn vị: ${doctor.single.company_id}',
                      style: TextStyle(
                        color: Color(MyColors.grey02),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Image(
                image: NetworkImage(
                    'http://27.71.25.107/web/static/img/${doctor.single.title}.jpg' ??
                        '${AppAsset.doctor05}'),
                width: 150, // Đặt chiều rộng của ảnh
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: bottomBar(context),
        appBar: _appBar(context),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DetailBody(),
            ),
          ],
        ),
      ),
    );
  }
}
