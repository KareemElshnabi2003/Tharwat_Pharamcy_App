import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class BodyTermsWidget extends StatelessWidget {
  final String body;

  const BodyTermsWidget({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return TextNormalWidget(
        text: body,
        color: ThemeService.secondaryTextColor,
        size: 3.5.w,
        weight: FontWeight.w500,
        multi: true,
        numOfRow: 20); // زيادة عدد الأسطر لكي تظهر الشروط بالكامل
  }
}
