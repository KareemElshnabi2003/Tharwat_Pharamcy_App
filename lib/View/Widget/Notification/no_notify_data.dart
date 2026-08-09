import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class NoNotifyDataWidget extends StatelessWidget {
  final String image;
  final String title;
  final String body;

  const NoNotifyDataWidget({
    super.key,
    required this.image,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 60.w,
            height: 60.w,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 2.h),
          TextNormalWidget(
            text: title,
            color: LightMode.mainColor,
            size: 5.w,
            weight: FontWeight.bold,
          ),
          SizedBox(height: 2.h),
          TextNormalWidget(
            text: body,
            color: LightMode.mainColor,
            size: 4.w,
            weight: FontWeight.w500,
            center: true,
          ),
        ],
      ),
    );
  }
}