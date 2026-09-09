import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Auth/forget_pass_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Widget/Auth/icon_login_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.canPop(context)
                ? Get.back()
                : Get.off(() => const LoginPage());
          });
        },
        child: Scaffold(
          backgroundColor: ThemeService.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppBarPageWidget(
                    back: true,
                    onPress: () {
                      Navigator.canPop(context)
                          ? Get.back()
                          : Get.off(() => const LoginPage());
                    },
                    title: "Reset your password",
                    colorIcon: LightMode.mainColor,
                    colorText: LightMode.mainColor),
                SizedBox(
                  height: 5.w,
                ),
                Image.asset(
                  AppImages.resetPassImage,
                  width: 70.w,
                  height: 30.h,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 5.w,
                ),
                TextNormalWidget(
                    text: "Please enter your email to send your OTP code",
                    color: ThemeService.textColor,
                    size: 3.w,
                    weight: FontWeight.w500),
                GetBuilder<ForgetPassController>(
                  init: ForgetPassController(), // تهيئة الـ Controller هنا
                  builder: (controller) => Form(
                      key: controller.forgetPassKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: 5.w, left: 5.w, bottom: 10.w, top: 5.w),
                            child: TextFieldWidget(
                                controller: controller.emailController,
                                hintText: "Email",
                                iconic: false,
                                obscure: false,
                                validator: (val) {
                                  return controller.emailValidtor(val!);
                                },
                                keyBoard: TextInputType.emailAddress,
                                onPress: null,
                                icon: Icons.email),
                          ),
                          controller.statuesRequest == StatuesRequest.loading
                              ? LoadingWidget(height: 7.h)
                              : ButtonWidget(
                                  colorBorder: ThemeService.primaryColor,
                                  colorFill: ThemeService.primaryColor,
                                  colorText: LightMode.whiteColor,
                                  width: 90.w,
                                  text: "Next",
                                  onPress: () {
                                    controller.forgetPass();
                                  },
                                  size: 5.w),
                          SizedBox(
                            height: 15.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 35.w,
                                child: Divider(
                                  color: ThemeService.unselectedColor,
                                ),
                              ),
                              TextNormalWidget(
                                  text: "    OR     ",
                                  color:
                                      LightMode.greyColor.withValues(alpha: .5),
                                  size: 4.w,
                                  weight: FontWeight.bold),
                              SizedBox(
                                width: 35.w,
                                child: Divider(
                                  color: ThemeService.unselectedColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          IconLoginWidget(
                              img: AppImages.watsAppImage, onPress: () {}),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
