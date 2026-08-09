import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_click_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class TitleSectionHomeWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressSeeAll;
  final bool margin;

  const TitleSectionHomeWidget({
    super.key,
    required this.title,
    required this.onPressSeeAll,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ? EdgeInsets.only(right: 6.w, left: 6.w) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextNormalWidget(
            text: title,
            color: ThemeService.textColor,
            size: 4.w,
            weight: FontWeight.bold,
          ),
          TextClickWidget(
            text: "See all",
            decoration: false,
            onPress: onPressSeeAll,
            color: ThemeService.isDark ? LightMode.orangeColor : LightMode.mainColor,
            size: 3.5.w,
          ),
        ],
      ),
    );
  }
}