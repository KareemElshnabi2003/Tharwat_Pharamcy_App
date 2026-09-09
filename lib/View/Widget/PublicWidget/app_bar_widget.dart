import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class AppBarPageWidget extends StatelessWidget {
  final bool back;
  final VoidCallback? onPress;
  final String title;
  final Color colorText;
  final Color colorIcon;

  const AppBarPageWidget({
    super.key,
    required this.back,
    this.onPress,
    required this.title,
    required this.colorText,
    required this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.w, left: 5.w, top: 6.h, bottom: 2.w),
      child: Row(
        children: [
          back
              ? InkWell(
                  onTap: onPress,
                  child: SizedBox(
                      width: 10.w,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: colorIcon,
                        size: 5.w,
                      )))
              : SizedBox(width: 10.w),
          Container(
            alignment: Alignment.center,
            width: 70.w,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                  color: colorText, fontSize: 5.w, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}
