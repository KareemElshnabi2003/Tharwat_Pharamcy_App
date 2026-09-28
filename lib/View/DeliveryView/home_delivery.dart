// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Delivery%20View/home_delivery_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/main.dart';

class HomeDelivery extends StatelessWidget {
  const HomeDelivery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeDeliveryController>(
      init: HomeDeliveryController(),
      builder: (controller) => Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: sharedPreferences!.getString("Mood") == "Dark"
              ? LightMode.nightColor
              : LightMode.whiteColor,
          height: MediaQuery.sizeOf(context).shortestSide > 600 ? 12.h : 10.5.h,
          padding: EdgeInsets.only(right: 2.w, left: 2.w),
          notchMargin: 4.w,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: sharedPreferences!.getString("Mood") == "Dark"
                        ? LightMode.darkMainColor
                        : LightMode.whiteColor,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.solid,
                    blurRadius: 3,
                    offset: const Offset(0, -3)),
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.w),
                  topRight: Radius.circular(5.w)),
              color: sharedPreferences!.getString("Mood") == "Dark"
                  ? LightMode.nightColor
                  : LightMode.mainColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                itemNavigationBar("Available", () {
                  controller.change_1();
                  controller.changePage(0);
                },
                    img: true,
                    null,
                    22.w,
                    controller.currentIndex == 0
                        ? LightMode.whiteColor
                        : LightMode.whiteColor.withValues(alpha: .5),
                    controller.choose_1),
                itemNavigationBar("Active", () {
                  controller.change_2();

                  controller.changePage(1);
                },
                    img: true,
                    null,
                    22.w,
                    controller.currentIndex == 1
                        ? LightMode.whiteColor
                        : LightMode.whiteColor.withValues(alpha: .5),
                    controller.choose_2),
                itemNavigationBar("Completed", () {
                  controller.change_3();

                  controller.changePage(2);
                },
                    img: true,
                    null,
                    22.w,
                    controller.currentIndex == 2
                        ? LightMode.whiteColor
                        : LightMode.whiteColor.withValues(alpha: .5),
                    controller.choose_3),
              ],
            ),
          ),
        ),
        body: controller.pages.elementAt(controller.currentIndex),
      ),
    );
  }

  Widget itemNavigationBar(text, onTap, icon, width, color, choose,
      {img = false}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (choose == true)
              Container(
                height: 1.w,
                width: 10.w,
                decoration: BoxDecoration(
                    color: LightMode.whiteColor,
                    borderRadius: BorderRadius.circular(10.w)),
              ),
            SizedBox(height: 1.w),
            img
                ? Image.asset(
                    AppImages.trafficImage,
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.fill,
                  )
                : Icon(
                    icon,
                    size: 6.w,
                    color: color,
                  ),
            SizedBox(height: 1.w),
            Text(
              text,
              style: GoogleFonts.poppins(
                  color: color, fontWeight: FontWeight.bold, fontSize: 3.5.w),
            )
          ],
        ),
      ),
    );
  }
}
