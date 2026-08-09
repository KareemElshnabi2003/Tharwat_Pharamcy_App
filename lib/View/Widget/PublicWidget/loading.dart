import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';

class LoadingWidget extends StatelessWidget {
  final double height;
  const LoadingWidget({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 100.w,
      child: const Center(
        child: CircularProgressIndicator(
          color: LightMode.mainColor,
        ),
      ),
    );
  }
}