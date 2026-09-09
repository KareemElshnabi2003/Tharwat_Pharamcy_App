import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Payment/check_out_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/order_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/home.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class SuccessOrder extends StatelessWidget {
  final OrderModel orderModel;
  const SuccessOrder({
    super.key,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    Get.put(
        CheckOutController()); // قمنا بحذف تعريف المتغير إذا لم نكن نستخدمه لتنظيف الكود

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
        homeController.goToHome(0, null);
      });
        },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(right: 5.w, left: 5.w, top: 6.h, bottom: 2.h),
            child: Column(
              children: [
                Image.asset(
                  AppImages.doneImage,
                  width: 40.w,
                  height: 18.h,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextNormalWidget(
                    text: "Order Successful",
                    color: LightMode.mainColor,
                    size: 4.w,
                    weight: FontWeight.w700),
                const SizedBox(
                  height: 10,
                ),
                TextNormalWidget(
                    center: true,
                    text:
                        "Congratulations! Your order has been successfully proceed. We will pick up your order as soon as possible!",
                    color: ThemeService.isDark
                        ? LightMode.whiteBlueColor
                        : LightMode.blackColor.withValues(alpha: .5),
                    size: 3.w,
                    weight: FontWeight.w700),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: LightMode.mainColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppImages.trafficImage,
                            width: 8.w,
                            height: 8.w,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextNormalWidget(
                                  text: "ORDER ID #${orderModel.id}",
                                  color: ThemeService.textColor,
                                  size: 3.5.w,
                                  weight: FontWeight.w700),
                              TextNormalWidget(
                                  text: "Tharwat Pharmacy",
                                  color: ThemeService.unselectedColor,
                                  size: 3.w,
                                  weight: FontWeight.w500),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: LightMode.mainColor, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "Customer Name",
                                    color: ThemeService.unselectedColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text: "Total Cost",
                                    color: ThemeService.unselectedColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text:
                                        "${orderModel.user ?? sharedPreferences!.getString("name")}",
                                    color: ThemeService.isDark
                                        ? LightMode.whiteBlueColor
                                        : LightMode.blackColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text: "${orderModel.total} EGP",
                                    color: LightMode.orangeColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "Order Date",
                                    color: ThemeService.unselectedColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text: "Order Time",
                                    color: ThemeService.unselectedColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text:
                                        "${Get.find<CheckOutController>().editDate(orderModel.createdAt)}",
                                    color: ThemeService.isDark
                                        ? LightMode.whiteBlueColor
                                        : LightMode.blackColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text:
                                        "${Get.find<CheckOutController>().edittime(orderModel.createdAt)}",
                                    color: ThemeService.isDark
                                        ? LightMode.whiteBlueColor
                                        : LightMode.blackColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "Payment Method",
                                    color: ThemeService.unselectedColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text: "Contact Number",
                                    color: ThemeService.unselectedColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: orderModel.paymentMethod ?? "",
                                    color: ThemeService.isDark
                                        ? LightMode.whiteBlueColor
                                        : LightMode.blackColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text: orderModel.phone ?? "",
                                    color: ThemeService.isDark
                                        ? LightMode.whiteBlueColor
                                        : LightMode.blackColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextNormalWidget(
                                text: "Address",
                                color: ThemeService.unselectedColor,
                                size: 3.w,
                                weight: FontWeight.w600),
                            const SizedBox(
                              height: 5,
                            ),
                            TextNormalWidget(
                                text:
                                    "${orderModel.address} , ${orderModel.street} , ${orderModel.buildingNum}",
                                multi: true,
                                numOfRow: 4,
                                color: ThemeService.isDark
                                    ? LightMode.whiteBlueColor
                                    : LightMode.blackColor,
                                size: 3.w,
                                weight: FontWeight.w600),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                    colorBorder: ThemeService.primaryColor,
                    colorFill: ThemeService.primaryColor,
                    colorText: LightMode.whiteColor,
                    margin: false,
                    size: 3.5.w,
                    text: "Back to home",
                    width: 90.w,
                    onPress: () {
                      homeController.currentIndex = 0;
                      Get.offAll(() => const Home());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
