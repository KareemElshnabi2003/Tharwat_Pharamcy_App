import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

void bottomSheetMessage({
  VoidCallback? onPressYes,
  VoidCallback? onPressNo,
  required BuildContext context,
  required String title,
  required String body,
  bool field = false,
  String? Function(String?)? validator,
  String? hintText,
  TextEditingController? controller,
  Key? key,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: ThemeService.backgroundColor,
    context: context,
    builder: (context) => Container(
      height: field ? 40.h : 32.h,
      padding: EdgeInsets.only(
          top: 5.w, bottom: MediaQuery.of(context).viewInsets.bottom, right: 5.w, left: 5.w),
      child: Form(
        key: field ? key : null,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10.w,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: ThemeService.isDark ? LightMode.mainColor : LightMode.blackColor,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70.w,
                    child: TextNormalWidget(
                        text: title, color: LightMode.mainColor, size: 4.5.w, weight: FontWeight.w700, center: true),
                  ),
                  SizedBox(width: 10.w)
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: 90.w,
                  child: TextNormalWidget(
                      text: body,
                      center: true,
                      color: ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.blackColor,
                      size: 4.w,
                      weight: FontWeight.w600)),
              const SizedBox(height: 20),
              if (field && controller != null && hintText != null)
                TextFieldWidget(
                  controller: controller,
                  hintText: hintText,
                  validator: validator,
                  icon: Icons.location_on_outlined,
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                      colorBorder: LightMode.redColor,
                      colorFill: ThemeService.backgroundColor,
                      colorText: LightMode.redColor,
                      margin: false,
                      onPress: onPressNo ?? () => Get.back(),
                      size: 3.5.w,
                      text: "Cancel",
                      width: 35.w),
                  const SizedBox(width: 20),
                  ButtonWidget(
                      colorBorder: ThemeService.primaryColor,
                      colorFill: ThemeService.primaryColor,
                      text: "Confirm",
                      onPress: onPressYes,
                      colorText: LightMode.whiteColor,
                      size: 3.5.w,
                      width: 35.w,
                      margin: false),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}