import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class ButtonFilterWidget extends StatelessWidget {
  final Color colorBorder;
  final Color colorFill;
  final Color colorText;
  final double? width;
  final String text;
  final VoidCallback onPress;
  final double size;

  const ButtonFilterWidget({
    super.key,
    required this.colorBorder,
    required this.colorFill,
    required this.colorText,
    this.width,
    required this.text,
    required this.onPress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      splashFactory: NoSplash.splashFactory,
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 3.w, left: 3.w),
        width: width,
        decoration: BoxDecoration(
          color: colorFill,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(color: colorBorder),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
              color: colorText, fontSize: size, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
