import 'dart:async';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:doctor_care/config/agora.config.dart' as config;
import 'package:test_agora/components/example_actions_widget.dart';
import 'package:test_agora/components/log_sink.dart';
import 'package:test_agora/components/basic_video_configuration_widget.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:test_agora/src/model/doctor.dart';
import 'package:test_agora/core/colors.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:logger/logger.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_agora/core/app_style.dart';
import 'package:test_agora/core/app_color.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'dart:io';

const appId = "3e5fa9beb897407fbee021af67a07449";
const token =
    "0063e5fa9beb897407fbee021af67a07449IAAmEP7bJJ3y4JH2pAM55HdEluc8+SjRtqgh8ABMEaacqdW/WTQh39v0IgBw7rBv0UcWZQQAAQBhBBVlAgBhBBVlAwBhBBVlBABhBBVl";

const channel = "tsbsdaothikimdung";
const appCertificate = '544750d742b74619b9507f563176f0cc';

ChannelProfileType _channelProfileType =
    ChannelProfileType.channelProfileLiveBroadcasting;

class AgoraScreen extends StatefulWidget {
  final Doctor doctor;
  final String token;
  // final String token;
  const AgoraScreen({Key? key, required this.doctor, required this.token})
      : super(key: key);

  @override
  State<AgoraScreen> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  late final RtcEngine _engine;
  static final _logger = Logger();

  bool isJoined = false, switchCamera = true, switchRender = true;
  Set<int> remoteUid = {};
  late TextEditingController _controller;
  bool _isUseFlutterTexture = false;
  bool _isUseAndroidSurfaceView = false;
  String? serialNumber;
  @override
  void initState() {
    super.initState();
    // _controller = TextEditingController(text: config.channelId);

    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    // await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: appId,
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        logSink.log(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        setState(() {
          remoteUid.add(rUid);
        });
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        logSink.log(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));

    await _engine.enableVideo();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.doctor.channel!,
      uid: int.parse(widget.doctor.id),
      options: ChannelMediaOptions(
        channelProfile: _channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
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
                        buildStatusIcon(widget.doctor),
                        widget.doctor.consultancy == 'false'
                            ? SizedBox() // Nếu doctor.consultancy là false, không hiển thị gì cả
                            : Text(
                                widget.doctor.consultancy ?? '',
                                style: TextStyle(
                                    color: Color(MyColors.header01),
                                    fontWeight: FontWeight.w700),
                              ),
                      ],
                    ),
                    Text(
                      widget.doctor.title ?? '',
                      style: TextStyle(
                          color: Color(MyColors.header01),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Kênh: ${widget.doctor.channel}',
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
                    'http://27.71.25.107/web/static/img/${widget.doctor.title}.jpg' ??
                        ''),
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
    return ExampleActionsWidget(
      displayContentBuilder: (context, isLayoutHorizontal) {
        return Stack(
          children: [
            AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
                useFlutterTexture: _isUseFlutterTexture,
                useAndroidSurfaceView: _isUseAndroidSurfaceView,
              ),
              onAgoraVideoViewCreated: (viewId) {
                _engine.startPreview();
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.of(remoteUid.map(
                    (e) => SizedBox(
                      width: 170,
                      height: 170,
                      child: AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: e),
                          connection:
                              RtcConnection(channelId: widget.doctor.channel),
                          useFlutterTexture: _isUseFlutterTexture,
                          useAndroidSurfaceView: _isUseAndroidSurfaceView,
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            )
          ],
        );
      },
      actionsBuilder: (context, isLayoutHorizontal) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: isJoined ? _leaveChannel : _joinChannel,
                    child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
                  ),
                )
              ],
            ),
            if (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS) ...[
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightBlack,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _leaveChannel();
                      Navigator.pop(context);
                    },
                    // => controller.addToCart(doctor),
                    child: const Text("Back"),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: _switchCamera,
                    child: Text('Camera ${switchCamera ? 'front' : 'rear'}'),
                  ),
                ],
              ),
            ],
            DetailDoctorCard(),
          ],
        );
      },
    );
    // if (!_isInit) return Container();
  }
}
