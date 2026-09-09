import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final String orderNum;
  final String price;
  final String status;
  final VoidCallback? onPressYes;
  final String date;
  final VoidCallback? onPressDetails;
  final VoidCallback? onPressTrack;
  final int index;
  final bool delivery;

  const OrderCardWidget({
    super.key,
    required this.orderNum,
    required this.price,
    this.status = "none",
    this.onPressYes,
    required this.date,
    this.onPressDetails,
    this.onPressTrack,
    required this.index,
    this.delivery = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: LightMode.mainColor, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextNormalWidget(
                  text: orderNum,
                  color: LightMode.mainColor,
                  size: 4.w,
                  weight: FontWeight.w600),
              TextNormalWidget(
                  text: index == 0
                      ? "Pending"
                      : index == 1
                          ? "Active"
                          : index == 2
                              ? "Completed"
                              : "Canceled",
                  color: index == 0
                      ? LightMode.greyColor
                      : index == 1
                          ? LightMode.orangeColor
                          : index == 2
                              ? LightMode.greenColor
                              : LightMode.redColor,
                  size: 3.5.w,
                  weight: FontWeight.w700),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextNormalWidget(
                      text: "Total Price",
                      color: ThemeService.unselectedColor,
                      size: 3.w,
                      weight: FontWeight.w600),
                  TextNormalWidget(
                      text: price,
                      color: LightMode.mainColor,
                      size: 3.w,
                      weight: FontWeight.w500),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: 5.h,
                    child: VerticalDivider(
                        thickness: 2, color: ThemeService.unselectedColor),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextNormalWidget(
                          text: "Date & Time",
                          color: ThemeService.unselectedColor,
                          size: 3.w,
                          weight: FontWeight.w600),
                      TextNormalWidget(
                          text: date,
                          color: LightMode.mainColor,
                          size: 3.w,
                          weight: FontWeight.w500),
                    ],
                  ),
                  const SizedBox(width: 50)
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonWidget(
                  colorBorder: ThemeService.primaryColor,
                  colorFill: ThemeService.primaryColor,
                  colorText: LightMode.whiteColor,
                  margin: false,
                  onPress: onPressDetails,
                  size: 3.w,
                  text: "View Details",
                  width: delivery && status != "none" ? 40.w : 83.w),
              if (status == "finsh")
                ButtonWidget(
                    colorBorder: LightMode.mainColor,
                    colorFill: LightMode.whiteBlueColor,
                    colorText: LightMode.mainColor,
                    margin: false,
                    onPress: () {
                      bottomSheetMessage(
                          body:
                              "Are you sure you finished delivering the order?",
                          context: context,
                          onPressNo: () => Get.back(),
                          onPressYes: onPressYes,
                          title: "Finish Order");
                    },
                    size: 4.w,
                    text: "Finish",
                    width: 40.w),
              if (status == "active")
                ButtonWidget(
                    colorBorder: LightMode.mainColor,
                    colorFill: LightMode.whiteBlueColor,
                    colorText: LightMode.mainColor,
                    margin: false,
                    onPress: () {
                      bottomSheetMessage(
                          body: "Are you sure you want to accept the order?",
                          context: context,
                          onPressNo: () => Get.back(),
                          onPressYes: onPressYes,
                          title: "Accept Order");
                    },
                    size: 3.5.w,
                    text: "Accept Order",
                    width: 40.w),
            ],
          )
        ],
      ),
    );
  }
}
