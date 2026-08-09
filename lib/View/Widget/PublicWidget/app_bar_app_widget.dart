import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class AppBarWidget extends StatelessWidget {
  final VoidCallback? onPressBack;
  final VoidCallback? onPressNotify;
  final String title;
  final bool notify;
  final bool colorWhite;
  final bool colorBlue;

  const AppBarWidget({
    super.key,
    this.onPressBack,
    this.onPressNotify,
    required this.title,
    this.notify = true,
    this.colorWhite = false,
    this.colorBlue = false,
  });

  @override
  Widget build(BuildContext context) {
    // قمنا بتجميع شروط الألوان هنا لجعل الكود أنظف
    Color elementsColor = colorBlue
        ? LightMode.mainColor
        : colorWhite
        ? LightMode.whiteColor
        : ThemeService.primaryColor;

    return Container(
      margin: EdgeInsets.only(right: 5.w, left: 5.w, top: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 10.w,
            child: InkWell(
              onTap: onPressBack,
              child: Icon(
                Icons.arrow_back_ios,
                color: elementsColor,
              ),
            ),
          ),
          SizedBox(
            width: 70.w,
            child: Center(
              child: TextNormalWidget(
                text: title,
                color: elementsColor,
                size: 5.w,
                weight: FontWeight.bold,
              ),
            ),
          ),
          !notify
              ? SizedBox(
            width: 10.w,
          )
              : SizedBox(
            width: 10.w,
            child: InkWell(
              onTap: onPressNotify,
              child: Icon(
                Icons.notifications_none,
                color: elementsColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}