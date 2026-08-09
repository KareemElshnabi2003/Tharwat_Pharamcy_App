import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

SnackBar snackBarWidget({required String message}) {
  return SnackBar(
    content: TextNormalWidget(
      text: message,
      color: LightMode.blackColor,
      size: 3.w,
      weight: FontWeight.w600,
      center: true,
    ),
    padding: const EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 15),
    backgroundColor: Colors.green,
  );
}