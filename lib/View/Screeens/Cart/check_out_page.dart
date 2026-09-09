import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Payment/check_out_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CheckOutController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<CheckOutController>(
        builder: (controller) => controller.statuesRequest ==
                StatuesRequest.loading
            ? LoadingWidget(height: 100.h)
            : SingleChildScrollView(
                child: Form(
                  key: controller.checkKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBarPageWidget(
                              back: true,
                              onPress: () => Get.back(),
                              title: "Check Out",
                              colorText: ThemeService.isDark
                                  ? LightMode.mainColor
                                  : LightMode.blackColor,
                              colorIcon: ThemeService.isDark
                                  ? LightMode.mainColor
                                  : LightMode.blackColor),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextNormalWidget(
                                    text: "Delivery details",
                                    color: ThemeService.secondaryTextColor,
                                    size: 4.w,
                                    weight: FontWeight.w600),
                                const SizedBox(height: 10),
                                TextNormalWidget(
                                    text: "Address (in details) : ",
                                    color: LightMode.mainColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextFieldWidget(
                                    controller: controller.addressController,
                                    hintText: "(country - governorate - city )",
                                    icon: Icons.location_on_outlined,
                                    validator: (val) =>
                                        controller.addressValidtor(val!)),
                                const SizedBox(height: 20),
                                TextNormalWidget(
                                    text: "Street (in details) : ",
                                    color: LightMode.mainColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextFieldWidget(
                                    controller: controller.streetController,
                                    hintText: "Street",
                                    icon: Icons.streetview,
                                    validator: (val) =>
                                        controller.streetValidtor(val!)),
                                const SizedBox(height: 20),
                                TextNormalWidget(
                                    text: "Building Number : ",
                                    color: LightMode.mainColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextFieldWidget(
                                    controller: controller.buildingController,
                                    hintText: "Building",
                                    keyBoard: TextInputType.number,
                                    icon: Icons.home,
                                    validator: (val) =>
                                        controller.buildingValidtor(val!)),
                                const SizedBox(height: 20),
                                TextNormalWidget(
                                    text: "Additional Info :",
                                    color: LightMode.mainColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextFieldWidget(
                                    controller:
                                        controller.additionalInfoController,
                                    hintText: "Additional Information",
                                    icon: Icons.info,
                                    validator: (val) => controller
                                        .additionalInfoValidtor(val!)),
                                const SizedBox(height: 20),
                                TextNormalWidget(
                                    text: "Phone :",
                                    color: LightMode.mainColor,
                                    size: 3.w,
                                    weight: FontWeight.w600),
                                TextFieldWidget(
                                    controller: controller.phoneController,
                                    hintText: "Phone Number",
                                    keyBoard: TextInputType.phone,
                                    icon: Icons.phone,
                                    validator: (val) =>
                                        controller.phoneValidtor(val!)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "Total Cost",
                                    color: ThemeService.textColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w700),
                                TextNormalWidget(
                                    text: "${controller.totalCost} EGP",
                                    color: LightMode.orangeColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w700),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ButtonWidget(
                                colorBorder: ThemeService.primaryColor,
                                colorFill: ThemeService.primaryColor,
                                colorText: LightMode.whiteColor,
                                margin: false,
                                onPress: () {
                                  log("pressssssssss");
                                  controller.craeteOrder();
                                },
                                size: 3.5.w,
                                text: "Confirm",
                                width: 90.w),
                            const SizedBox(height: 30)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
