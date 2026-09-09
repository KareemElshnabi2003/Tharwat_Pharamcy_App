import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class ItemNotifyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;

  const ItemNotifyWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.w),
          color: ThemeService.isDark
              ? LightMode.darkMainColor
              : LightMode.whiteBlueColor,
        ),
        child: Icon(
          icon,
          color: LightMode.lightMainColor,
          size: 6.w,
        ),
      ),
      title: TextNormalWidget(
          text: title,
          color:
              ThemeService.isDark ? LightMode.mainColor : LightMode.blackColor,
          size: 3.5.w,
          weight: FontWeight.w600),
      subtitle: TextNormalWidget(
          text: subtitle,
          color: ThemeService.isDark
              ? LightMode.whiteBlueColor
              : LightMode.blackColor.withValues(alpha: .5),
          size: 3.2.w,
          weight: FontWeight.w600),
      trailing: TextNormalWidget(
          text: trailing,
          color: LightMode.mainColor,
          size: 3.2.w,
          weight: FontWeight.w700),
    );
  }
}
