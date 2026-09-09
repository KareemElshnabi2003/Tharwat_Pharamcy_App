import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا GetBuilder مع init للتهيئة بدلاً من Get.put العشوائية
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: ThemeService.backgroundColor,
          height: MediaQuery.sizeOf(context).shortestSide > 600 ? 12.h : 10.5.h,
          padding: EdgeInsets.only(right: 2.w, left: 2.w),
          notchMargin: 4.w,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: ThemeService.isDark
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
              color: ThemeService.isDark
                  ? LightMode.nightColor
                  : LightMode.mainColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                itemNavigationBar("Home", () {
                  controller.change_1();
                  controller.changePage(0);
                },
                    Icons.home_filled,
                    22.w,
                    controller.currentIndex == 0
                        ? LightMode.whiteColor
                        : LightMode.whiteColor.withValues(alpha: .5),
                    controller.choose_1),
                itemNavigationBar("Favorites", () {
                  controller.change_2();
                  controller.changePage(1);
                },
                    Icons.favorite,
                    18.w,
                    controller.currentIndex == 1
                        ? LightMode.whiteColor
                        : LightMode.whiteColor.withValues(alpha: .5),
                    controller.choose_2),
                itemNavigationBar("Scan", () {
                  controller.change_3();
                  controller.changePage(2);
                },
                    Icons.qr_code_scanner,
                    20.w,
                    controller.currentIndex == 2
                        ? LightMode.whiteColor
                        : LightMode.whiteColor.withValues(alpha: .5),
                    controller.choose_3),
                itemNavigationBar("Profile", () {
                  controller.change_4();
                  controller.changePage(3);
                },
                    Icons.person,
                    20.w,
                    controller.currentIndex == 3
                        ? LightMode.whiteColor
                        : LightMode.whiteColor.withValues(alpha: .5),
                    controller.choose_4),
              ],
            ),
          ),
        ),
        body: controller.pages.elementAt(controller.currentIndex),
      ),
    );
  }

  Widget itemNavigationBar(String text, VoidCallback onTap, IconData icon,
      double width, Color color, bool choose) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (choose)
              Container(
                height: 1.w,
                width: 10.w,
                decoration: BoxDecoration(
                    color: LightMode.whiteColor,
                    borderRadius: BorderRadius.circular(10.w)),
              ),
            SizedBox(height: 1.w),
            Icon(icon, size: 6.w, color: color),
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
