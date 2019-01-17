import 'package:flutter/material.dart';
import '../constants/color.dart';

class GlobalConfig {
  static bool dark = true;
  static ThemeData themeData = new ThemeData.light().copyWith(
      //primaryColor: Color(AppColors.AppBarColor),
      //cardColor: Color(AppColors.AppBarColor)
      );
  static Color searchBackgroundColor = Colors.white10;
  static Color cardBackgroundColor = new Color(0xFF222222);
  static Color fontColor = Colors.white30;
}
