import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class SuccsessResetPass extends StatefulWidget {
  const SuccsessResetPass({super.key});

  @override
  State<SuccsessResetPass> createState() => _SuccsessResetPassState();
}

class _SuccsessResetPassState extends State<SuccsessResetPass> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => const LoginPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.primaryColor,
      body: SizedBox(
        width: 100.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.succsessImage,
                width: 25.w, height: 25.w, fit: BoxFit.fill),
            SizedBox(height: 5.w),
            TextNormalWidget(
                text: "Welcome Back!",
                color: LightMode.whiteColor,
                size: 7.w,
                weight: FontWeight.bold),
            SizedBox(height: 5.w),
            SizedBox(
              width: 80.w,
              child: TextNormalWidget(
                  text:
                      "You have successfully reset and created a new password. You will be redirected to the Login Page within moments.",
                  color: LightMode.whiteColor,
                  size: 4.w,
                  center: true,
                  multi: true,
                  numOfRow: 4,
                  weight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
