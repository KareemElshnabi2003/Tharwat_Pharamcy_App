import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/profile_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<ProfileController>(
        builder: (controller) => Form(
          key: controller.deleteKey,
          child: Column(
            children: [
              AppBarWidget(colorBlue: true, notify: false, colorWhite: false, onPressBack: () => Get.back(), title: "Delete My Account"),
              const SizedBox(height: 15),
              SizedBox(
                width: 80.w,
                child: TextNormalWidget(text: "Please, Enter your password to confirm deleting your account", color: ThemeService.textColor, size: 3.5.w, weight: FontWeight.w600, center: true),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: TextFieldWidget(controller: controller.passOldController, hintText: "Password", obscure: controller.show, onPress: () => controller.changeShow(), iconic: true, validator: (val) => controller.passwordOldValidtor(val!), icon: Icons.lock),
              ),
              const SizedBox(height: 50),
              ButtonWidget(
                  colorBorder: ThemeService.primaryColor,
                  colorFill: ThemeService.primaryColor,
                  colorText: LightMode.whiteColor,
                  margin: true,
                  onPress: () {
                    bottomSheetMessage(body: "Are you sure you want to delete your account?", context: context, onPressNo: () => Get.back(), onPressYes: () => controller.deleteAcc(), title: "Delete My Account");
                  },
                  size: 5.w, text: "Confirm", width: 90.w)
            ],
          ),
        ),
      ),
    );
  }
}