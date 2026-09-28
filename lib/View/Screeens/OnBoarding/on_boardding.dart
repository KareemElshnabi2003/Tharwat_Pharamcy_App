import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/OnBoaeding/on_boarding_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Widget/OnBoarding/dotted_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/OnBoarding/on_board_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class OnBoardding extends StatelessWidget {
  const OnBoardding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<OnBoardingController>(
        init: OnBoardingController(),
        builder: (controller) => SingleChildScrollView(
          child: SizedBox(
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.indexList == 0)
                  OnBoardWidget(
                      back: false,
                      img: controller.onBoardingList[0]['img'],
                      title: controller.onBoardingList[0]['title'],
                      body: controller.onBoardingList[0]['body'],
                      onPress: () => controller.changIndex(0)),
                if (controller.indexList == 1)
                  OnBoardWidget(
                      back: true,
                      img: controller.onBoardingList[1]['img'],
                      title: controller.onBoardingList[1]['title'],
                      body: controller.onBoardingList[1]['body'],
                      onPress: () => controller.changIndex(0)),
                if (controller.indexList == 2)
                  OnBoardWidget(
                      back: true,
                      img: controller.onBoardingList[2]['img'],
                      title: controller.onBoardingList[2]['title'],
                      body: controller.onBoardingList[2]['body'],
                      onPress: () => controller.changIndex(1)),
                Column(
                  children: [
                    Center(
                      child: ButtonWidget(
                          colorBorder: ThemeService.primaryColor,
                          colorFill: ThemeService.primaryColor,
                          colorText: LightMode.whiteColor,
                          width: 90.w,
                          text: "Next",
                          onPress: () {
                            if (controller.indexList == 0) {
                              controller.changIndex(1);
                            } else if (controller.indexList == 1) {
                              controller.changIndex(2);
                            } else {
                              sharedPreferences!
                                  .setString("pageStart", "Login");
                              Get.offAll(() => const LoginPage());
                            }
                          },
                          size: 5.w),
                    ),
                    SizedBox(height: 5.w),
                    DottedListWidget(index: controller.indexList),
                    SizedBox(height: 5.w),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
