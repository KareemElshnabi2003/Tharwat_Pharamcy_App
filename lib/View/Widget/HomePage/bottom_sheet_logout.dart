import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

void bottomSheetLogOut({required VoidCallback onPressYes, required BuildContext context}) {
  showModalBottomSheet(
    backgroundColor: LightMode.whiteColor,
    context: context,
    builder: (context) => Container(
      height: 16.h,
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.close, color: LightMode.blackColor, size: 5.w),
              ),
              TextNormalWidget(text: "هل تريد تسجيل الخروج؟", color: LightMode.blackColor, size: 4.5.w, weight: FontWeight.w700),
              const SizedBox()
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  colorBorder: LightMode.mainColor,
                  colorFill: LightMode.mainColor,
                  text: "نعم",
                  onPress: onPressYes,
                  colorText: LightMode.whiteColor,
                  size: 3.5.w,
                  width: 30.w,
                  margin: false),
              const SizedBox(width: 20),
              ButtonWidget(
                  colorBorder: LightMode.mainColor,
                  colorFill: LightMode.whiteColor,
                  colorText: LightMode.mainColor,
                  margin: false,
                  onPress: () => Get.back(),
                  size: 3.5.w,
                  text: "لا",
                  width: 30.w),
            ],
          ),
        ],
      ),
    ),
  );
}