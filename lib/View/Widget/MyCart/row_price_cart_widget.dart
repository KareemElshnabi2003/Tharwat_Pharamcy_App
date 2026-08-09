import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class RowPriceWidget extends StatelessWidget {
  final String title;
  final String price;
  final bool total;

  const RowPriceWidget({
    super.key,
    required this.title,
    required this.price,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextNormalWidget(
            text: title,
            color: total
                ? (ThemeService.isDark ? LightMode.orangeColor : LightMode.redColor)
                : (ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.blackColor),
            size: 3.w,
            weight: FontWeight.w700),
        TextNormalWidget(
            text: "\$$price",
            color: total
                ? (ThemeService.isDark ? LightMode.orangeColor : LightMode.redColor)
                : (ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.blackColor),
            size: 3.w,
            weight: FontWeight.w700),
      ],
    );
  }
}