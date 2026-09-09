import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/Profile/body_terms_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/Profile/title_terms_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class TermsOfServices extends StatelessWidget {
  const TermsOfServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
          ? LightMode.nightColor
          : LightMode.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarPageWidget(
                back: true,
                onPress: () {
                  Get.back();
                },
                title: "Terms Of Service",
                colorText: LightMode.mainColor,
                colorIcon: LightMode.mainColor),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTermsWidget(text: "1. Use of Services:"),
                  BodyTermsWidget(
                      body:
                          '''You must be at least [age] years old to use our services. By accessing our services, you agree to use them only for lawful purposes and in accordance with these Terms.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "2. User Accounts:"),
                  BodyTermsWidget(
                      body:
                          '''- You may need to create an account to access certain features.
- You are responsible for maintaining the confidentiality of your account information.
- You agree to notify us immediately of any unauthorized access to your account.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "3. Prohibited Activities:"),
                  BodyTermsWidget(body: '''You agree not to:
- Violate any applicable laws or regulations.
- Attempt to gain unauthorized access to our services.
- Engage in any activity that disrupts or interferes with the operation of our services.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "4. Intellectual Property:"),
                  BodyTermsWidget(
                      body:
                          '''All content, trademarks, and intellectual property related to our services remain the exclusive property of [Your Company/App Name]. You may not use, copy, modify, or distribute our content without permission.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "5. Termination:"),
                  BodyTermsWidget(
                      body:
                          '''We reserve the right to terminate or suspend your access to our services at our discretion, without notice, if you violate these Terms.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(
                      text: "6. Disclaimers and Limitation of Liability:"),
                  BodyTermsWidget(
                      body:
                          '''- Our services are provided "as is" without warranties of any kind.
- We are not responsible for any direct, indirect, incidental, or consequential damages arising from your use of our services.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "7. Changes to These Terms:"),
                  BodyTermsWidget(
                      body:
                          '''We may update these Terms from time to time. Continued use of our services after changes take effect constitutes your acceptance of the revised Terms.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "8. Governing Law:"),
                  BodyTermsWidget(
                      body:
                          '''These Terms are governed by and construed in accordance with the laws of [Your Country/State].'''),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
