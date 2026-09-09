import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';

class DottedListWidget extends StatelessWidget {
  final int index;

  const DottedListWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDot(0),
          _buildDot(1),
          _buildDot(2),
        ],
      ),
    );
  }

  Widget _buildDot(int dotIndex) {
    bool isActive = index == dotIndex;
    return Container(
      width: 3.w,
      height: 3.w,
      padding: EdgeInsets.all(.5.w),
      decoration: BoxDecoration(
          color: ThemeService.isDark
              ? LightMode.darkMainColor
              : LightMode.whiteColor,
          border: Border.all(
            color: isActive
                ? (ThemeService.isDark
                    ? LightMode.darkMainColor
                    : LightMode.mainColor)
                : (ThemeService.isDark
                    ? LightMode.greyColor
                    : LightMode.whiteColor),
          ),
          shape: BoxShape.circle),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (ThemeService.isDark
                    ? LightMode.darkMainColor
                    : LightMode.mainColor)
                : LightMode.greyColor),
      ),
    );
  }
}
