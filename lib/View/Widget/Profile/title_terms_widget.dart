import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class TitleTermsWidget extends StatelessWidget {
  final String text;

  const TitleTermsWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextNormalWidget(
        text: text,
        color: ThemeService.textColor,
        size: 3.5.w,
        weight: FontWeight.w700);
  }
}