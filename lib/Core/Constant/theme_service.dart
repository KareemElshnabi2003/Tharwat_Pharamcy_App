import 'package:flutter/material.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/main.dart';

class ThemeService {
  // دالة للتحقق من الوضع الحالي (مظلم أو مضيء)
  static bool get isDark => sharedPreferences!.getString("Mood") == "Dark";

  // الألوان الديناميكية بناءً على الوضع
  static Color get backgroundColor =>
      isDark ? LightMode.nightColor : LightMode.whiteColor;

  static Color get primaryColor =>
      isDark ? LightMode.darkMainColor : LightMode.mainColor;

  static Color get textColor =>
      isDark ? LightMode.whiteColor : LightMode.blackColor;

  static Color get secondaryTextColor => isDark
      ? LightMode.whiteBlueColor
      : LightMode.blackColor.withValues(alpha: .5);

  static Color get unselectedColor =>
      isDark ? LightMode.greyColor : LightMode.blackColor.withValues(alpha: .5);
}
