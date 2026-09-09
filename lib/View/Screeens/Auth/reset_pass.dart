import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Auth/forget_pass_controller.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Widget/Auth/body_auth_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';

class ResetPass extends StatelessWidget {
  const ResetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const LoginPage());
      });
        },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarPageWidget(
                back: false,
                title: "Change password",
                colorText: LightMode.mainColor,
                colorIcon: LightMode.mainColor,
              ),
              bodyAuthTextPageWidget("",
                  "Your new password must be different from previous used passwords."),
              GetBuilder<ForgetPassController>(
                  init: ForgetPassController(),
                  builder: (controller) => Form(
                      key: controller.resetPassKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.w),
                            child: TextFieldWidget(
                              controller: controller.passwordController,
                              hintText: "Password",
                              icon: Icons.lock,
                              obscure: controller.show_1,
                              iconic: true,
                              onPress: () => controller.changeShow_1(),
                              validator: (val) =>
                                  controller.passwordValidtor(val!),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.w),
                            child: TextFieldWidget(
                              controller: controller.passwordConfirmController,
                              hintText: "Confirm Password",
                              icon: Icons.lock,
                              obscure: controller.show_2,
                              iconic: true,
                              onPress: () => controller.changeShow_2(),
                              validator: (val) =>
                                  controller.passwordConfirmValidtor(val!),
                            ),
                          ),
                          controller.statuesRequest == StatuesRequest.loading
                              ? LoadingWidget(height: 7.h)
                              : ButtonWidget(
                                  colorBorder: ThemeService.primaryColor,
                                  colorFill: ThemeService.primaryColor,
                                  colorText: LightMode.whiteColor,
                                  width: 90.w,
                                  text: "Confirm",
                                  onPress: () => controller.resetPass(),
                                  size: 5.w,
                                  margin: false,
                                ),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
