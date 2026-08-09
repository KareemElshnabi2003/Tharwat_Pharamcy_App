import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';

class ButtomFilterWidget extends StatelessWidget {
  final VoidCallback onPressApply;
  final VoidCallback onPressResetFilter;

  const ButtomFilterWidget({
    super.key,
    required this.onPressApply,
    required this.onPressResetFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 4.w, left: 4.w, top: 3.w, bottom: 3.w),
      decoration: BoxDecoration(
          color: ThemeService.backgroundColor,
          borderRadius: BorderRadius.circular(3.w),
          border: const Border(
              top: BorderSide(color: LightMode.mainColor, width: 1.5),
              right: BorderSide(color: LightMode.mainColor, width: 1.5),
              left: BorderSide(color: LightMode.mainColor, width: 1.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonWidget(
              colorBorder: LightMode.mainColor,
              colorFill: ThemeService.backgroundColor,
              colorText: LightMode.mainColor,
              text: "Reset Filter",
              onPress: onPressResetFilter,
              size: 3.w,
              width: 34.w),
          ButtonWidget(
              colorBorder: ThemeService.primaryColor,
              colorFill: ThemeService.primaryColor,
              colorText: LightMode.whiteColor,
              text: "Apply",
              onPress: onPressApply,
              size: 3.w,
              width: 30.w),
        ],
      ),
    );
  }
}