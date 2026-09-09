import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';

Widget otpWidget(String verifyCode, Function(String) onSubmit) {
  return Center(
    child: SizedBox(
      height: 12.h,
      width: 90.w,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: OtpTextField(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textStyle: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: LightMode.mainColor),
          fieldWidth: 10.w,
          fieldHeight: 7.h,
          borderColor: LightMode.whiteColor,
          borderWidth: 2,
          numberOfFields: 6,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          fillColor: ThemeService.backgroundColor,
          filled: false,
          borderRadius: BorderRadius.circular(20),
          showFieldAsBox: true,
          disabledBorderColor: LightMode.mainColor,
          enabledBorderColor: LightMode.mainColor,
          onSubmit: onSubmit,
        ),
      ),
    ),
  );
}
