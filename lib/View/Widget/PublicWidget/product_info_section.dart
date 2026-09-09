import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class ProductInfoSectionWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool moreRead;
  final String title;
  final String body;

  const ProductInfoSectionWidget({
    super.key,
    required this.onTap,
    required this.moreRead,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextNormalWidget(
                  text: title,
                  color: ThemeService.textColor,
                  size: 4.w,
                  weight: FontWeight.bold),
              Icon(
                moreRead
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: LightMode.mainColor,
                size: 10.w,
              )
            ],
          ),
        ),
        if (moreRead)
          TextNormalWidget(
              text: body,
              color: ThemeService.isDark
                  ? LightMode.whiteBlueColor
                  : LightMode.blackColor.withValues(alpha: .5),
              size: 3.w,
              weight: FontWeight.w500)
      ],
    );
  }
}
