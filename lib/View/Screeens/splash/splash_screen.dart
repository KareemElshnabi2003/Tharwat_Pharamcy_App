import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/home_delivery.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/verify_forget_pass.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/verify_sign.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/home.dart';
import 'package:tharwat_pharmacy/View/Screeens/OnBoarding/on_boardding.dart';
import 'package:tharwat_pharmacy/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool endSplashColor = false;
  bool secondImage = false;
  double topContainer = 0;
  double bottomContainer = 100.h;
  bool animationOneStart = false;
  bool animationTwoStart = false;
  bool animationThirdStart = false;
  double size = .4;
  double opecity = 1;
  double leftContainer = 20.w;

  @override
  void initState() {
    Timer(
        const Duration(milliseconds: 200),
        () => setState(() {
              animationOneStart = true;
              topContainer = 0.h;
              bottomContainer = 100.h;
              leftContainer = 20.w;
              secondImage = false;
            }));
    Timer(
        const Duration(milliseconds: 1200),
        () => setState(() {
              topContainer = 37.5.h;
              bottomContainer = 37.5.h;
              leftContainer = 20.w;
            }));
    Timer(
        const Duration(milliseconds: 2200),
        () => setState(() {
              secondImage = true;
            }));
    Timer(
        const Duration(milliseconds: 2700),
        () => setState(() {
              topContainer = 33.h;
              bottomContainer = 33.h;
              leftContainer = 15.w;
              animationTwoStart = true;
              animationOneStart = false;
              secondImage = false;
            }));
    Timer(
        const Duration(milliseconds: 3500),
        () => setState(() {
              topContainer = -100.h;
              bottomContainer = -100.h;
              leftContainer = -100.w;
            }));
    Timer(
        const Duration(milliseconds: 4500),
        () => setState(() {
              animationTwoStart = false;
              endSplashColor = true;
              secondImage = true;
            }));
    Timer(
        const Duration(milliseconds: 5500),
        () => setState(() {
              animationThirdStart = true;
            }));
    Timer(
        const Duration(milliseconds: 5700),
        () => setState(() {
              size = 30;
              opecity = 0;
            }));

    Timer(const Duration(milliseconds: 6800), () {
      String? pageStart = sharedPreferences!.getString("pageStart");
      if (pageStart == "Home") {
        Get.offAll(() => const Home(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 1200));
      } else if (pageStart == "HomeDelivery") {
        Get.offAll(() => const HomeDelivery(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 1200));
      } else if (pageStart == "Login") {
        Get.offAll(() => const LoginPage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 1200));
      } else if (pageStart == "VerifyForget") {
        Get.offAll(() => const VerifyForgetPass(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 1200));
      } else if (pageStart == "VerifySign") {
        Get.offAll(() => const VerifySign(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 1200));
      } else {
        Get.offAll(() => const OnBoardding(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 1200));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: endSplashColor
          ? ThemeService.primaryColor
          : ThemeService.backgroundColor,
      body: Stack(
        children: [
          if (animationOneStart)
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              curve: Curves.linear,
              top: topContainer,
              left: leftContainer,
              right: leftContainer,
              bottom: bottomContainer,
              child: Container(
                  width: 55.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                      color: ThemeService.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3))
                      ])),
            ),
          if (animationTwoStart)
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              top: topContainer,
              bottom: bottomContainer,
              left: leftContainer,
              right: leftContainer,
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeService.isDark
                      ? LightMode.darkMainColor
                      : LightMode.whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: LightMode.mainColor.withValues(alpha: .2),
                      width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: ThemeService.isDark
                            ? LightMode.darkMainColor.withValues(alpha: .2)
                            : LightMode.mainColor.withValues(alpha: 0.2),
                        spreadRadius: 8,
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                  gradient: RadialGradient(
                    colors: [
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      LightMode.whiteColor,
                      ThemeService.isDark
                          ? LightMode.darkMainColor.withValues(alpha: .02)
                          : LightMode.whiteColor,
                      ThemeService.isDark
                          ? LightMode.darkMainColor.withValues(alpha: .02)
                          : LightMode.whiteColor,
                      ThemeService.isDark
                          ? LightMode.darkMainColor.withValues(alpha: .02)
                          : LightMode.whiteColor,
                      ThemeService.isDark
                          ? LightMode.darkMainColor.withValues(alpha: 0.02)
                          : LightMode.mainColor.withValues(alpha: .02),
                    ],
                  ),
                ),
              ),
            ),
          animationThirdStart
              ? AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  opacity: opecity,
                  child: AnimatedScale(
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    scale: size,
                    child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                            secondImage ? AppImages.logo_1 : AppImages.logo_2,
                            fit: BoxFit.fill)),
                  ),
                )
              : Container(
                  width: 100.w,
                  height: 100.h,
                  alignment: Alignment.center,
                  child: Image.asset(
                      secondImage ? AppImages.logo_1 : AppImages.logo_2,
                      width: 40.w,
                      height: 40.w)),
        ],
      ),
    );
  }
}
