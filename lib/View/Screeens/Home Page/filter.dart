import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/filter_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/Filter/buttom_filter_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/button_filter_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FilterController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<FilterController>(
        builder: (controller) => Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: 100.h,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // يرجى التأكد من تحويل appBarWidget لكلاس أو استخدامها كدالة مؤقتاً
                    AppBarWidget(
                      onPressBack: () => Get.back(),
                      notify: false,
                      title: "Filter",
                    ),
                    SizedBox(height: 2.h),

                    Padding(
                      padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h),
                      child: TextNormalWidget(
                          text: "Price Range",
                          color: ThemeService.isDark
                              ? LightMode.mainColor
                              : LightMode.blackColor,
                          size: 4.w,
                          weight: FontWeight.bold),
                    ),
                    RangeSlider(
                      activeColor: ThemeService.isDark
                          ? LightMode.darkMainColor
                          : LightMode.mainColor,
                      inactiveColor: LightMode.whiteBlueColor,
                      values: controller.currentRangeValues,
                      max: 100,
                      divisions: 10,
                      labels: RangeLabels(
                        controller.currentRangeValues.start.round().toString(),
                        controller.currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        controller.setPrice(values);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      width: 100.w,
                      height: 5.h,
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => TextNormalWidget(
                              text: controller.ranges[index],
                              color: ThemeService.isDark
                                  ? LightMode.whiteBlueColor
                                  : LightMode.blackColor,
                              size: 3.w,
                              weight: FontWeight.w600),
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 3.w),
                          itemCount: controller.ranges.length),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h),
                      child: TextNormalWidget(
                          text: "Availability",
                          color: ThemeService.isDark
                              ? LightMode.mainColor
                              : LightMode.blackColor,
                          size: 4.w,
                          weight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 1.h, right: 3.w),
                          height: 4.h,
                          child: ButtonFilterWidget(
                              // إذا قمت بتحويلها لـ Class استخدم ButtonFilterWidget
                              colorBorder: controller.chooseAllAvailable
                                  ? (ThemeService.isDark
                                      ? LightMode.darkMainColor
                                      : LightMode.mainColor)
                                  : LightMode.greyColor,
                              colorFill: controller.chooseAllAvailable
                                  ? (ThemeService.isDark
                                      ? LightMode.darkMainColor
                                      : LightMode.mainColor)
                                  : LightMode.greyColor,
                              colorText: controller.chooseAllAvailable
                                  ? LightMode.whiteColor
                                  : LightMode.blackColor.withValues(alpha: .5),
                              text: "All",
                              onPress: () => controller.chooseAllAvailabel(),
                              size: 3.w),
                        ),
                        Container(
                          width: 74.w,
                          height: 4.h,
                          margin:
                              EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w),
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 2.w),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                bool isSelected = controller.available ==
                                    controller.availablety[index]['name'];
                                return ButtonFilterWidget(
                                    colorBorder: isSelected
                                        ? (ThemeService.isDark
                                            ? LightMode.darkMainColor
                                            : LightMode.mainColor)
                                        : LightMode.greyColor,
                                    colorFill: isSelected
                                        ? (ThemeService.isDark
                                            ? LightMode.darkMainColor
                                            : LightMode.mainColor)
                                        : LightMode.greyColor,
                                    colorText: isSelected
                                        ? LightMode.whiteColor
                                        : LightMode.blackColor
                                            .withValues(alpha: .5),
                                    text: controller.availablety[index]['name'],
                                    onPress: () =>
                                        controller.addToMapAvailabel(index),
                                    size: 3.w);
                              },
                              itemCount: controller.availablety.length),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 3.w,
                left: 3.w,
                child: ButtomFilterWidget(
                    // استخدم ButtomFilterWidget لو حولتها لكلاس
                    onPressApply: () => controller.saveData(),
                    onPressResetFilter: () => controller.clearData())),
          ],
        ),
      ),
    );
  }
}
