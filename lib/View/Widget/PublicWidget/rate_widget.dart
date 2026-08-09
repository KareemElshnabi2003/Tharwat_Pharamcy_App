import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class RateWidget extends StatelessWidget {
  final double rate;
  final int numOfStar;

  const RateWidget({
    super.key,
    required this.rate,
    required this.numOfStar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          numOfStar > 5 ? 5 : numOfStar,
              (index) => Padding(
            padding: EdgeInsets.only(right: 1.w),
            child: Icon(
              Icons.star,
              color: LightMode.yellowColor,
              size: 3.5.w,
            ),
          ),
        ),
        SizedBox(width: 1.w),
        TextNormalWidget(text: "$rate", color: LightMode.blackColor, size: 3.w, weight: FontWeight.w600),
      ],
    );
  }
}