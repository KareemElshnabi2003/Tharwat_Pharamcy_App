import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

void messageError(String title, String body,
    {bool back = false, VoidCallback? onPressBack}) {
  if (Get.testMode || Get.context == null) return;
  Get.defaultDialog(
    backgroundColor: ThemeService.backgroundColor,
    title: title,
    titlePadding: EdgeInsets.all(2.w),
    titleStyle: GoogleFonts.poppins(
        color: LightMode.mainColor, fontSize: 6.w, fontWeight: FontWeight.w500),
    content: Column(
      children: [
        SizedBox(
          width: 80.w,
          child: TextNormalWidget(
              text: body,
              center: true,
              color: ThemeService.isDark
                  ? LightMode.whiteBlueColor
                  : LightMode.blackColor,
              size: 3.5.w,
              weight: FontWeight.w400),
        ),
        SizedBox(height: 4.w),
        ButtonWidget(
            colorBorder: ThemeService.primaryColor,
            colorFill: ThemeService.primaryColor,
            colorText: LightMode.whiteColor,
            width: 60.w,
            text: "Cancel",
            onPress: back
                ? onPressBack
                : () {
                    Get.appUpdate();
                    Get.back();
                  },
            size: 3.w),
        SizedBox(height: 2.w),
      ],
    ),
  );
}

void messageErrorVerify(String title, String body, VoidCallback onPress) {
  if (Get.testMode || Get.context == null) return;
  Get.defaultDialog(
    backgroundColor: ThemeService.backgroundColor,
    title: title,
    titlePadding: EdgeInsets.all(2.w),
    titleStyle: GoogleFonts.poppins(
        color: LightMode.mainColor, fontSize: 6.w, fontWeight: FontWeight.w500),
    content: Column(
      children: [
        SizedBox(
          width: 80.w,
          child: TextNormalWidget(
              text: body,
              center: true,
              color: ThemeService.isDark
                  ? LightMode.whiteBlueColor
                  : LightMode.blackColor,
              size: 3.5.w,
              weight: FontWeight.w400),
        ),
        SizedBox(height: 4.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
                colorBorder: ThemeService.primaryColor,
                colorFill: LightMode.whiteBlueColor,
                colorText: LightMode.mainColor,
                width: 25.w,
                text: "Cancel",
                onPress: () => Get.back(),
                size: 3.w),
            const SizedBox(width: 20),
            ButtonWidget(
                colorBorder: ThemeService.primaryColor,
                colorFill: ThemeService.primaryColor,
                colorText: LightMode.whiteColor,
                width: 25.w,
                text: "Verify",
                onPress: onPress,
                size: 3.w),
          ],
        ),
        SizedBox(height: 2.w),
      ],
    ),
  );
}

void messageErrorWithButton(
    String title, String body, VoidCallback onPress, String btnTitle) {
  if (Get.testMode || Get.context == null) return;
  Get.defaultDialog(
    backgroundColor: ThemeService.backgroundColor,
    title: title,
    titlePadding: EdgeInsets.all(2.w),
    titleStyle: GoogleFonts.poppins(
        color: LightMode.mainColor, fontSize: 6.w, fontWeight: FontWeight.w500),
    content: Column(
      children: [
        SizedBox(
          width: 80.w,
          child: TextNormalWidget(
              text: body,
              center: true,
              color: ThemeService.isDark
                  ? LightMode.whiteBlueColor
                  : LightMode.blackColor,
              size: 3.5.w,
              weight: FontWeight.w400),
        ),
        SizedBox(height: 4.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
                colorBorder: ThemeService.primaryColor,
                colorFill: LightMode.whiteBlueColor,
                colorText: LightMode.mainColor,
                width: 25.w,
                text: "Cancel",
                onPress: () => Get.back(),
                size: 3.w),
            const SizedBox(width: 20),
            ButtonWidget(
                colorBorder: ThemeService.primaryColor,
                colorFill: ThemeService.primaryColor,
                colorText: LightMode.whiteColor,
                width: 25.w,
                text: btnTitle,
                onPress: onPress,
                size: 3.w),
          ],
        ),
        SizedBox(height: 2.w),
      ],
    ),
  );
}

void messageChooseVerify(VoidCallback onPressWats, VoidCallback onPressEmail) {
  if (Get.testMode || Get.context == null) return;
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
              color: ThemeService.isDark
                  ? LightMode.whiteBlueColor
                  : LightMode.blackColor,
              size: 4.w,
              weight: FontWeight.w400),
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
                size: 3.5.w),
            ButtonWidget(
                colorBorder: ThemeService.primaryColor,
                colorFill: ThemeService.primaryColor,
                colorText: LightMode.whiteColor,
                width: 26.w,
                text: "Email",
                onPress: onPressEmail,
                size: 3.5.w),
          ],
        ),
        SizedBox(height: 2.w),
      ],
    ),
  );
}
