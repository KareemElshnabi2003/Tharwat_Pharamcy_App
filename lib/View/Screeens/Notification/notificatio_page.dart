import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Notification/notify_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/Notification/item_notify.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class NotificatioPage extends StatelessWidget {
  const NotificatioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<NotifyController>(
          init: NotifyController(),
          builder: (controller) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarPageWidget(
                    back: true,
                    onPress: () => Get.back(),
                    title: "Notification",
                    colorText: ThemeService.isDark
                        ? LightMode.mainColor
                        : LightMode.blackColor,
                    colorIcon: ThemeService.isDark
                        ? LightMode.mainColor
                        : LightMode.blackColor),
                Padding(
                  padding: EdgeInsets.only(right: 5.w, left: 5.w, top: 3.h),
                  child: TextNormalWidget(
                      text: "New",
                      color: ThemeService.isDark
                          ? LightMode.mainColor
                          : LightMode.blackColor,
                      size: 4.w,
                      weight: FontWeight.bold),
                ),
                Container(
                    margin: EdgeInsets.only(right: 6.w, left: 6.w),
                    width: 100.w,
                    padding: EdgeInsets.zero,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => const ItemNotifyWidget(
                          subtitle:
                              "We have new offers for you please check it .",
                          title: "New Offers",
                          icon: Icons.discount,
                          trailing: "Today"),
                    )),
                Padding(
                  padding: EdgeInsets.only(right: 5.w, left: 5.w, top: 3.h),
                  child: TextNormalWidget(
                      text: "Older",
                      color: ThemeService.isDark
                          ? LightMode.mainColor
                          : LightMode.blackColor,
                      size: 4.w,
                      weight: FontWeight.bold),
                ),
                Container(
                    margin: EdgeInsets.only(right: 6.w, left: 6.w),
                    height: 80.h,
                    width: 100.w,
                    padding: EdgeInsets.zero,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => const ItemNotifyWidget(
                          subtitle:
                              "We have new offers for you please check it .",
                          title: "New Offers",
                          icon: Icons.discount,
                          trailing: "Yesterday"),
                    )),
              ],
            ),
          ),
        ));
  }
}
