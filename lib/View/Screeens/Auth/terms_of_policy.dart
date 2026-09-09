import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/Profile/body_terms_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/Profile/title_terms_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class TermsOfPolicy extends StatelessWidget {
  const TermsOfPolicy({super.key});

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
                title: "Privacy Policy",
                colorText: LightMode.mainColor,
                colorIcon: LightMode.mainColor),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyTermsWidget(
                      body:
                          '''[Tharwat Pharmacy] we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our services.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "1. Information We Collect:"),
                  BodyTermsWidget(
                      body:
                          '''We may collect the following types of information:
- Personal Information: Name, email address, phone number, and other details you provide when registering or using our services.
- Usage Data: Information about how you interact with our services, including IP address, device information, and browsing activity.
- Cookies and Tracking Technologies: We may use cookies and similar technologies to enhance user experience and analyze usage trends.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "2. How We Use Your Information:"),
                  BodyTermsWidget(body: '''
We use the information we collect to:
- Provide, maintain, and improve our services.
- Personalize user experience.
- Send updates, promotions, and other communications (with your consent).
- Protect against fraudulent or unauthorized activities.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "3. How We Share Your Information:"),
                  BodyTermsWidget(
                      body:
                          '''We do not sell your personal data. However, we may share your information with:
- Service Providers: Third-party vendors who help us operate our services.
- Legal Authorities: If required by law or to protect our rights and users.
- Business Transfers: In case of a merger, acquisition, or sale of assets.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "4. Data Security:"),
                  BodyTermsWidget(
                      body:
                          '''We implement appropriate security measures to protect your information, but no method of transmission over the Internet is 100% secure. We encourage you to take precautions when sharing personal data.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "5. Your Rights and Choices:"),
                  BodyTermsWidget(body: '''You have the right to:
- Access, update, or delete your personal information.
- Opt-out of marketing communications.
- Disable cookies through browser settings.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "6. Third-Party Links:"),
                  BodyTermsWidget(
                      body:
                          '''Our services may contain links to third-party websites. We are not responsible for their privacy practices, and we encourage you to review their policies.'''),
                  SizedBox(
                    height: 20,
                  ),
                  TitleTermsWidget(text: "7. Changes to This Privacy Policy:"),
                  BodyTermsWidget(
                      body:
                          '''We may update this Privacy Policy from time to time. Continued use of our services after changes take effect constitutes your acceptance of the revised policy.'''),
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
