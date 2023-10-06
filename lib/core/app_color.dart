import 'package:flutter/material.dart';

class AppColor {
  const AppColor._();

  static const lightOrange = Color(0xFFFAA33C);
  static const lightBlack = Color(0xFF101725);
  static bool isLightMode = true;

  static Color primary() => const Color(0xFF3f84ed);
  static Color accent() => const Color(0xFFF5AC6E);
  static Color positive() => const Color(0xFF00C287);
  static Color negative() => const Color(0xFFEA394E);

  static Color text({bool? lightMode}) =>
      lightMode ?? AppColor.isLightMode ? Colors.black : Colors.white;
  static Color fadeText({bool? lightMode}) => lightMode ?? AppColor.isLightMode
      ? const Color.fromARGB(255, 185, 184, 184)
      : const Color(0xFFA8A8A8);
  static Color background({bool? lightMode}) =>
      lightMode ?? AppColor.isLightMode
          ? const Color.fromARGB(255, 247, 247, 247)
          : const Color(0xFF1C1E29);
  static Color containerBackground({bool? lightMode}) =>
      lightMode ?? AppColor.isLightMode
          ? Colors.white
          : const Color(0xFF262C3A);
}
