import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';

class ButtonWidget extends StatelessWidget {
  final Color colorBorder;
  final Color colorFill;
  final Color colorText;
  final double? width;
  final String text;
  final VoidCallback? onPress;
  final double size;
  final bool margin;

  const ButtonWidget({
    super.key,
    required this.colorBorder,
    required this.colorFill,
    required this.colorText,
    this.width,
    required this.text,
    this.onPress,
    required this.size,
    this.margin = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: LightMode.whiteColor,
      splashFactory: NoSplash.splashFactory,
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 2.w, bottom: 2.w),
        width: width,
        decoration: BoxDecoration(
          color: colorFill,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(color: colorBorder, width: 2),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: colorText,
            fontSize: size,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
