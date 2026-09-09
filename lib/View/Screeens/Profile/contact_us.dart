import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/contact_us_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContactUsController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<ContactUsController>(
        builder: (controller) => controller.statuesRequest ==
                StatuesRequest.loading
            ? LoadingWidget(height: 80.h)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    AppBarPageWidget(
                        back: true,
                        onPress: () => Get.back(),
                        title: "Contact Us",
                        colorText: LightMode.mainColor,
                        colorIcon: LightMode.mainColor),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.w),
                          margin: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                              color: LightMode.whiteBlueColor,
                              border: Border.all(
                                  color: LightMode.mainColor, width: 2),
                              borderRadius: BorderRadius.circular(30)),
                          child: Form(
                            key: controller.changePassKey,
                            child: Column(
                              children: [
                                TextNormalWidget(
                                    text:
                                        "Have questions or need support? Reach out to us—we're here to help!",
                                    color: LightMode.blackColor,
                                    size: 3.w,
                                    weight: FontWeight.normal,
                                    center: true),
                                const SizedBox(height: 20),
                                TextFieldWidget(
                                    controller: controller.userNameController,
                                    hintText: "User Name",
                                    icon: Icons.person,
                                    validator: (val) =>
                                        controller.userNameValidtor(val!)),
                                const SizedBox(height: 20),
                                TextFieldWidget(
                                    controller: controller.emailController,
                                    hintText: "Email",
                                    icon: Icons.email,
                                    validator: (val) =>
                                        controller.emailValidtor(val!)),
                                const SizedBox(height: 20),
                                TextFieldWidget(
                                    controller: controller.messageController,
                                    hintText: "Message",
                                    icon: Icons.message,
                                    lines: true,
                                    validator: (val) =>
                                        controller.messageValidtor(val!)),
                                const SizedBox(height: 20),
                                ButtonWidget(
                                    colorBorder: ThemeService.primaryColor,
                                    colorFill: ThemeService.primaryColor,
                                    colorText: LightMode.whiteColor,
                                    margin: false,
                                    onPress: () {
                                      bottomSheetMessage(
                                          title: "Send Your Message",
                                          body:
                                              "Are you sure you  want to send your message?",
                                          context: context,
                                          onPressNo: () => Get.back(),
                                          onPressYes: () =>
                                              controller.sendMesssage());
                                    },
                                    size: 3.5.w,
                                    text: "Confirm",
                                    width: 80.w),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 35.w,
                                child: const Divider(
                                    color: LightMode.mainColor, thickness: 2)),
                            SizedBox(
                                width: 20.w,
                                child: TextNormalWidget(
                                    center: true,
                                    text: "Our Links",
                                    color: LightMode.mainColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w600)),
                            SizedBox(
                                width: 35.w,
                                child: const Divider(
                                    color: LightMode.mainColor, thickness: 2)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () =>
                                    controller.urlLuncher("facebook"),
                                icon: Icon(Icons.facebook,
                                    color: LightMode.mainColor, size: 9.w)),
                            IconButton(
                                onPressed: () =>
                                    controller.urlLuncher("instagram"),
                                icon: Image.asset(AppImages.instaImage,
                                    width: 9.w, height: 9.w, fit: BoxFit.fill)),
                            IconButton(
                                onPressed: () =>
                                    controller.urlLuncher("twitter"),
                                icon: Image.asset(AppImages.twitterImage,
                                    width: 9.w, height: 9.w, fit: BoxFit.fill)),
                            IconButton(
                                onPressed: () =>
                                    controller.urlLuncher("watsapp"),
                                icon: Image.asset(AppImages.watsappImage,
                                    width: 9.w, height: 9.w, fit: BoxFit.fill))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
