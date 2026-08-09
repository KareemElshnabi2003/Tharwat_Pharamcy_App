import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Auth/verify_code_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/sign_up.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/otp_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_click_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class VerifySign extends StatelessWidget {
  const VerifySign({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyCodeController());
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.offAll(() => const LoginPage());
      },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<VerifyCodeController>(
          builder: (controller) => controller.statuesRequest == StatuesRequest.loading
              ? LoadingWidget(height: 80.h)
              : SingleChildScrollView(
            child: Column(
              children: [
                AppBarPageWidget(
                    back: true,
                    onPress: () => Get.offAll(() => const SignUp()),
                    title: "Enter OTP Code",
                    colorText: LightMode.mainColor,
                    colorIcon: LightMode.mainColor
                ),
                SizedBox(height: 5.w),
                Image.asset(AppImages.otpImage, width: 70.w, height: 30.h, fit: BoxFit.fill),
                SizedBox(height: 3.w),
                TextNormalWidget(
                    text: "We have sent OTP code to your email",
                    color: ThemeService.textColor,
                    size: 3.w,
                    weight: FontWeight.w400
                ),
                SizedBox(height: 3.w),
                otpWidget(controller.verifyCodeSign, (val) {
                  controller.setValSign(val);
                }),
                SizedBox(height: 3.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextNormalWidget(
                        text: "Didn't receive the code ?",
                        color: ThemeService.textColor,
                        size: 3.5.w,
                        weight: FontWeight.w500
                    ),
                    TextClickWidget(text: "Resend OTP",decoration:  true,onPress:  () {
                      controller.sendOTP();
                    },color:  LightMode.mainColor,size:  4.w),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}