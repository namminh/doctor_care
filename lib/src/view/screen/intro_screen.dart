import 'package:flutter/material.dart';
import 'package:test_agora/core/app_style.dart';
import 'package:test_agora/src/view/screen/login.dart';
import 'package:test_agora/core/app_data.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late bool isloading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isloading = true;
    });
    // Gọi hàm để tải dữ liệu từ API và lưu vào biến "data"

    await AppData.fetchDataDoctorFromApi();
    await AppData.fetchDataMessengerFromApi();
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('Xin chào Bác sĩ'),
                    WavyAnimatedText('Chạm để đăng nhập'),
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Register()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
