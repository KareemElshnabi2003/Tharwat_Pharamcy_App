import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';

class NoDataWidget extends StatelessWidget {
  final String text;
  const NoDataWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.h,
      width: 60.w,
      child: DottedBorder(
        dashPattern: const [8, 4],
        radius: const Radius.circular(10),
        strokeWidth: 1.5,
        borderType: BorderType.RRect,
        color: LightMode.mainColor,
        child: Center(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
                fontSize: 3.5.w,
                fontWeight: FontWeight.bold,
                color: LightMode.mainColor),
          ),
        ),
      ),
    );
  }
}
