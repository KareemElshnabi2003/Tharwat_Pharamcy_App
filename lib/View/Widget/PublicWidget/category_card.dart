import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class CategoryCardWidget extends StatelessWidget {
  final Widget image;
  final String text;
  final VoidCallback onPress;

  const CategoryCardWidget({
    super.key,
    required this.image,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: ThemeService.isDark
                ? LightMode.darkMainColor
                : LightMode.lightMainColor,
            radius: 9.w,
            child: image,
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: 20.w,
            child: TextNormalWidget(
              text: text,
              center: true,
              color: ThemeService.textColor,
              size: 3.5.w,
              multi: true,
              numOfRow: 2,
              weight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
