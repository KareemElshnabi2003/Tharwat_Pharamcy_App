import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/profile_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<ProfileController>(
        builder: (controller) => Form(
          key: controller.changePassKey,
          child: Column(
            children: [
              AppBarWidget(
                  colorBlue: true,
                  notify: false,
                  colorWhite: false,
                  onPressBack: () => Get.back(),
                  title: "Change Password"),
              const SizedBox(height: 15),
              SizedBox(
                width: 80.w,
                child: TextNormalWidget(
                    text:
                        "your new password must be different from previous used passwords.",
                    color: ThemeService.textColor,
                    size: 3.5.w,
                    weight: FontWeight.w600,
                    center: true),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: TextFieldWidget(
                    controller: controller.passOldController,
                    hintText: "Old Password",
                    obscure: controller.show,
                    onPress: () => controller.changeShow(),
                    iconic: true,
                    validator: (val) => controller.passwordOldValidtor(val!),
                    icon: Icons.lock),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: TextFieldWidget(
                    controller: controller.passNewController,
                    hintText: "New Password",
                    obscure: controller.show_1,
                    onPress: () => controller.changeShow_1(),
                    iconic: true,
                    validator: (val) => controller.passwordNewValidtor(val!),
                    icon: Icons.lock),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: TextFieldWidget(
                    controller: controller.passNewConfirmController,
                    hintText: "Confirm New Password",
                    obscure: controller.show_2,
                    onPress: () => controller.changeShow_2(),
                    iconic: true,
                    validator: (val) =>
                        controller.passwordConfirmValidtor(val!),
                    icon: Icons.lock),
              ),
              const SizedBox(height: 50),
              controller.statuesRequest == StatuesRequest.loading
                  ? LoadingWidget(height: 7.h)
                  : ButtonWidget(
                      colorBorder: ThemeService.primaryColor,
                      colorFill: ThemeService.primaryColor,
                      colorText: LightMode.whiteColor,
                      margin: true,
                      onPress: () {
                        bottomSheetMessage(
                            body:
                                "Are you sure you want to save your new password?",
                            context: context,
                            onPressNo: () => Get.back(),
                            onPressYes: () => controller.changePassword(),
                            title: "Save New Password?");
                      },
                      size: 5.w,
                      text: "Confirm",
                      width: 90.w)
            ],
          ),
        ),
      ),
    );
  }
}
