import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class SpecialCardWidget extends StatelessWidget {
  final String? decorationImage;
  final String titleBTN_1;
  final VoidCallback onPressBTN_2;
  final String descripe;
  final String offer;

  const SpecialCardWidget({
    super.key,
    this.decorationImage,
    required this.titleBTN_1,
    required this.onPressBTN_2,
    required this.descripe,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressBTN_2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 24.h,
       padding: EdgeInsets.all(3.w),
            width: 90.w,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              border: Border.all(color: LightMode.mainColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ButtonWidget(
                        colorBorder: LightMode.mainColor,
                        colorFill: LightMode.whiteBlueColor,
                        colorText: LightMode.blackColor,
                        width: 25.w,
                        text: titleBTN_1,
                        onPress: () {},
                        size: 2.5.w),
                    SizedBox(height: 1.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextNormalWidget(
                          bgcolor: !ThemeService.isDark,
                          text: descripe,
                          color: ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.blackColor,
                          size: 4.w,
                          weight: FontWeight.w600),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextNormalWidget(
                          bgcolor: !ThemeService.isDark,
                          text: offer,
                          color: ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.blackColor,
                          size: 4.w,
                          weight: FontWeight.w500),
                    ),
                    SizedBox(height: 2.h),
                    ButtonWidget(
                        colorBorder: ThemeService.primaryColor,
                        colorFill: ThemeService.primaryColor,
                        colorText: LightMode.whiteColor,
                        width: 30.w,
                        text: "Order now",
                        onPress: onPressBTN_2,
                        size: 3.3.w)
                  ],
                ),
                SizedBox(
                    width: 42.w,
                    height: 15.h,
                    child: decorationImage == null
                        ? Image.asset(AppImages.noImage, fit: BoxFit.fill)
                        : CachedNetworkImage(
                      imageUrl: decorationImage!,
                      fit: BoxFit.fill,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}