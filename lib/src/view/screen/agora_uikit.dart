import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test_agora/src/model/doctor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_agora/core/app_style.dart';

const appId = "3e5fa9beb897407fbee021af67a07449";
const token =
    "007eJxTYJjd66a9OZLvk9xxubW5DvGN9nIh3fLZU6sDmT9+EEhWalRgME41TUu0TEpNsrA0NzEwT0tKTTUwMkxMMzNPNDA3MbH8e1s4tSGQkUFiYSwLIwMEgviCDCXFScUpifklGZnZmbkppXnpDAwAOYoihg==";

const channel = "tsbsdaothikimdung";
const appCertificate = '544750d742b74619b9507f563176f0cc';

ChannelProfileType _channelProfileType =
    ChannelProfileType.channelProfileLiveBroadcasting;

class AgoraUIKit extends StatefulWidget {
  final Doctor doctor;
  // final String token;
  const AgoraUIKit({Key? key, required this.doctor}) : super(key: key);

  @override
  State<AgoraUIKit> createState() => _AgoraUIKitState();
}

class _AgoraUIKitState extends State<AgoraUIKit> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: "test",
      username: "user",
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      actions: [],
      leading: IconButton(
        icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black),
        onPressed: () {
          // controller.currentPageViewItemIndicator.value = 0;
          Navigator.pop(context);
        },
      ),
      title: Text(
        widget.doctor.title,
        style: h2Style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _appBar(context),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                client: client,
                addScreenSharing: false, // Add this to enable screen sharing
              ),
            ],
          ),
        ),
      ),
    );
  }
}
