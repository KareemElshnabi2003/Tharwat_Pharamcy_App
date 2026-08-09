import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class BottomProductInfoWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String price;

  const BottomProductInfoWidget({
    super.key,
    required this.onTap,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 3.w, top: 5.w, bottom: 2.w, right: 3.w),
      decoration: BoxDecoration(
          color: ThemeService.backgroundColor,
          border: const Border(
              left: BorderSide(color: LightMode.mainColor, width: 1.5),
              right: BorderSide(color: LightMode.mainColor, width: 1.5),
              top: BorderSide(color: LightMode.mainColor, width: 1.5)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3.w), topRight: Radius.circular(3.w))),
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              TextNormalWidget(
                  text: "Price",
                  color: ThemeService.isDark ? LightMode.whiteColor : LightMode.blackColor.withOpacity(.5),
                  size: 3.5.w,
                  weight: FontWeight.w700),
              SizedBox(height: 1.w),
              TextNormalWidget(
                  text: "$price \$",
                  color: LightMode.mainColor,
                  size: 3.5.w,
                  weight: FontWeight.bold)
            ],
          ),
          ButtonWidget(
              colorBorder: ThemeService.primaryColor,
              colorFill: ThemeService.primaryColor,
              colorText: LightMode.whiteColor,
              width: 45.w,
              text: "Add To Cart",
              onPress: onTap,
              size: 3.5.w)
        ],
      ),
    );
  }
}