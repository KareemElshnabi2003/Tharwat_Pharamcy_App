import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_click_widget.dart';

class CuponWidget extends StatelessWidget {
  final VoidCallback onPressConfirm;
  final TextEditingController couponController;

  const CuponWidget({
    super.key,
    required this.onPressConfirm,
    required this.couponController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 70.w,
          height: 4.5.h,
          child: TextFormField(
            controller: couponController,
            style: GoogleFonts.poppins(
                color: ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.mainColor,
                fontSize: 3.w,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              fillColor: ThemeService.isDark ? LightMode.darkMainColor : LightMode.whiteBlueColor,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.only(right: 3.w, left: 3.w, top: 2.w),
              hintStyle: GoogleFonts.poppins(
                  color: LightMode.mainColor,
                  fontSize: 3.w,
                  fontWeight: FontWeight.w500),
              hintText: "Voucher code",
            ),
          ),
        ),
        TextClickWidget(
            text: "Confirm",
            decoration: false,
            onPress: onPressConfirm,
            color: ThemeService.isDark ? LightMode.orangeColor : LightMode.redColor,
            size: 3.w),
        SizedBox(width: 2.w),
      ],
    );
  }
}