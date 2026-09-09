import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/home.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class SuccsessSign extends StatefulWidget {
  const SuccsessSign({super.key});

  @override
  State<SuccsessSign> createState() => _SuccsessSignState();
}

class _SuccsessSignState extends State<SuccsessSign> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => const Home());
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
                      "Your Account has been created Successfully. You will be redirected to the homepage within moments.",
                  color: LightMode.whiteColor,
                  center: true,
                  multi: true,
                  numOfRow: 4,
                  size: 4.w,
                  weight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
