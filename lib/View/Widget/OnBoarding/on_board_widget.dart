import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';

class OnBoardWidget extends StatelessWidget {
  final bool back;
  final String img;
  final String title;
  final String body;
  final VoidCallback onPress;

  const OnBoardWidget({
    super.key,
    required this.back,
    required this.img,
    required this.title,
    required this.body,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        back
            ? Container(
                margin: EdgeInsets.only(right: 5.w, left: 5.w, top: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: onPress,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: ThemeService.isDark
                              ? LightMode.orangeColor
                              : LightMode.mainColor,
                          size: 7.w,
                        )),
                  ],
                ),
              )
            : SizedBox(height: 10.h),
        SizedBox(height: 3.w),
        Image.asset(
          img,
          fit: BoxFit.fill,
          width: 80.w,
          height: 30.h,
        ),
        SizedBox(height: 3.w),
        SizedBox(
          width: 70.w,
          child: Text(
            title,
            style: GoogleFonts.poppins(
                color: ThemeService.textColor,
                fontSize: 7.w,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 7.w),
        SizedBox(
          width: 70.w,
          child: Text(
            body,
            style: GoogleFonts.poppins(
                color: LightMode.greyColor,
                fontSize: 4.w,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
