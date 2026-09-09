import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/home_delivery.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/home.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class SuccsessLogin extends StatefulWidget {
  const SuccsessLogin({super.key});

  @override
  State<SuccsessLogin> createState() => _SuccsessLoginState();
}

class _SuccsessLoginState extends State<SuccsessLogin> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      if (sharedPreferences!.getString("pageStart") == "HomeDelivery") {
        Get.offAll(() => const HomeDelivery());
      } else {
        Get.offAll(() => const Home());
      }
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
                weight: FontWeight.bold,
                center: true),
            SizedBox(height: 5.w),
            SizedBox(
              width: 80.w,
              child: TextNormalWidget(
                  text:
                      "You will be redirected to the homepage within moments.",
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
