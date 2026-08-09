import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';

class IconLoginWidget extends StatelessWidget {
  final String img;
  final VoidCallback onPress;

  const IconLoginWidget({
    super.key,
    required this.img,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 15.w,
        height: 15.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeService.backgroundColor,
            border: Border.all(color: LightMode.mainColor)),
        child: Image.asset(
          img,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}