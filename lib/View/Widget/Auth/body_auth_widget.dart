import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart'; // لا تنسَ هذا الاستدعاء

Widget bodyAuthTextPageWidget(String textOne, String textTwo) {
  return Container(
    margin: EdgeInsets.only(right: 5.w, left: 5.w, top: 2.w, bottom: 5.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          textOne,
          style: GoogleFonts.poppins(
              color: ThemeService.textColor, // استخدام مباشر وبسيط
              fontSize: 4.w,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 3.w,
        ),
        Text(
          textTwo,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              color: ThemeService.textColor, // استخدام مباشر وبسيط
              fontSize: 4.w,
              fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
