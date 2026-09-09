import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

void messageChooseVerify(VoidCallback onPressWats, VoidCallback onPressEmail) {
  Get.defaultDialog(
    backgroundColor: ThemeService.backgroundColor,
    title: "OTP",
    titlePadding: EdgeInsets.only(right: 2.w, left: 2.w, bottom: 2.w, top: 8.w),
    titleStyle: GoogleFonts.poppins(
        color: LightMode.mainColor, fontSize: 6.w, fontWeight: FontWeight.w500),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 2.w),
        SizedBox(
          width: 70.w,
          child: TextNormalWidget(
            text: "Choose where to send your OTP code",
            center: true,
            color: ThemeService.textColor,
            size: 4.w,
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ButtonWidget(
                colorBorder: LightMode.greenColor,
                colorFill: LightMode.whiteColor,
                colorText: LightMode.greenColor,
                width: 26.w,
                text: "WhatsApp",
                onPress: onPressWats,
                size: 3.5.w,
                margin: false),
            ButtonWidget(
                colorBorder: ThemeService.primaryColor,
                colorFill: ThemeService.primaryColor,
                colorText: LightMode.whiteColor,
                width: 26.w,
                text: "Email",
                onPress: onPressEmail,
                size: 3.5.w,
                margin: false),
          ],
        ),
        SizedBox(height: 2.w),
      ],
    ),
  );
}
