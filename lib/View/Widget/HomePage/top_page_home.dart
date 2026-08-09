import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/search_filter_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class TopPageHomeWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressShop;
  final VoidCallback? onPressNotify;
  final VoidCallback? onPressFilter;
  final TextEditingController? controller;
  final Function(String)? onChange;

  const TopPageHomeWidget({
    super.key,
    required this.title,
    this.onPressShop,
    this.onPressNotify,
    this.onPressFilter,
    this.controller,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7.h, right: 5.w, left: 5.w),
      height: 23.h,
      margin: EdgeInsets.only(right: 2.w, left: 2.w),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: ThemeService.isDark ? LightMode.darkMainColor : LightMode.whiteColor,
                spreadRadius: 2,
                blurStyle: BlurStyle.solid,
                blurRadius: 3,
                offset: const Offset(0, 3)),
          ],
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.w), bottomRight: Radius.circular(5.w)),
          color: ThemeService.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextNormalWidget(text: "Location", color: LightMode.whiteColor, size: 3.w, weight: FontWeight.w400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_rounded, color: LightMode.orangeColor, size: 4.w),
                  SizedBox(width: 1.w),
                  TextNormalWidget(text: title, color: LightMode.whiteColor, size: 3.5.w, weight: FontWeight.w400),
                  SizedBox(width: 1.w),
                  Icon(Icons.arrow_drop_down, color: LightMode.orangeColor, size: 7.w),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onPressShop,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.w),
                        color: ThemeService.isDark ? LightMode.darkMainColor : LightMode.lightMainColor,
                      ),
                      child: Icon(Icons.shopping_cart, color: LightMode.whiteColor, size: 5.w),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  InkWell(
                    onTap: onPressNotify,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.w),
                        color: ThemeService.isDark ? LightMode.darkMainColor : LightMode.lightMainColor,
                      ),
                      child: Icon(Icons.notifications_rounded, color: LightMode.whiteColor, size: 5.w),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 4.w),
          SearchFilterWidget(
            onPressFilter: onPressFilter,
            onChange: onChange,
            controller: controller,
            colorBorderIconFilter: LightMode.whiteColor,
            colorFill: ThemeService.isDark ? LightMode.lightMainColor : LightMode.whiteColor,
            colorIconFilter: ThemeService.isDark ? LightMode.whiteColor : LightMode.blackColor,
            colorIconSearch: ThemeService.isDark ? LightMode.whiteColor : LightMode.blackColor,
            colorText: ThemeService.isDark ? LightMode.whiteColor : LightMode.blackColor,
          )
        ],
      ),
    );
  }
}