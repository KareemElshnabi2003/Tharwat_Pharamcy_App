import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class PlusMinusWidget extends StatelessWidget {
  final VoidCallback onPressPlus;
  final VoidCallback onPressMinus;
  final int number;

  const PlusMinusWidget({
    super.key,
    required this.onPressPlus,
    required this.onPressMinus,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onPressMinus,
          child: Container(
              padding: EdgeInsets.all(.5.w),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeService.backgroundColor,
                  border: Border.all(
                    color: LightMode.mainColor,
                  )),
              child: Icon(
                Icons.remove,
                color: LightMode.mainColor,
                size: 4.w,
              )),
        ),
        SizedBox(width: 2.w),
        TextNormalWidget(
            text: "$number",
            color: ThemeService.textColor,
            size: 5.w,
            weight: FontWeight.w500),
        SizedBox(width: 2.w),
        InkWell(
          onTap: onPressPlus,
          child: Container(
              padding: EdgeInsets.all(.5.w),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeService.backgroundColor,
                  border: Border.all(
                    color: LightMode.mainColor,
                  )),
              child: Icon(
                Icons.add,
                color: LightMode.mainColor,
                size: 4.w,
              )),
        ),
      ],
    );
  }
}
