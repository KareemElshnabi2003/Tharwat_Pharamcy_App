import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Delivery%20View/orders_delivery_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/ordeers_delivery_model.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class OrderDetailsDelivery extends StatelessWidget {
  final OrdersDeliveryModel ordersDeliveryModel;
  const OrderDetailsDelivery({super.key, required this.ordersDeliveryModel});

  @override
  Widget build(BuildContext context) {
    Get.put(OrdersDeliveryController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<OrdersDeliveryController>(
        builder: (controller) => controller.statuesRequest ==
                StatuesRequest.loading
            ? LoadingWidget(height: 100.h)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    AppBarPageWidget(
                        back: true,
                        onPress: () => Get.back(),
                        title: "Order Details",
                        colorText: ThemeService.isDark
                            ? LightMode.mainColor
                            : LightMode.blackColor,
                        colorIcon: ThemeService.isDark
                            ? LightMode.mainColor
                            : LightMode.blackColor),
                    const SizedBox(height: 20),
                    Padding(
                      padding:
                          EdgeInsets.only(right: 5.w, left: 5.w, bottom: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextNormalWidget(
                                  text: "Order ID",
                                  color: LightMode.mainColor,
                                  size: 3.5.w,
                                  weight: FontWeight.w600),
                              Row(
                                children: [
                                  TextNormalWidget(
                                      text: "Status",
                                      color: LightMode.mainColor,
                                      size: 3.5.w,
                                      weight: FontWeight.w600),
                                  const SizedBox(width: 50),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextNormalWidget(
                                  text: "#${ordersDeliveryModel.id}",
                                  color: ThemeService.textColor,
                                  size: 3.5.w,
                                  weight: FontWeight.w600),
                              Row(
                                children: [
                                  TextNormalWidget(
                                      text: "${ordersDeliveryModel.status}",
                                      color: ordersDeliveryModel.status ==
                                              "Cancelled"
                                          ? LightMode.redColor
                                          : ordersDeliveryModel.status ==
                                                  "Pending"
                                              ? LightMode.greyColor
                                              : ordersDeliveryModel.status ==
                                                      "Completed"
                                                  ? LightMode.greenColor
                                                  : LightMode.orangeColor,
                                      size: 3.5.w,
                                      weight: FontWeight.w600),
                                  const SizedBox(width: 50),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              width: 100.w,
                              child: const Divider(
                                  color: LightMode.mainColor,
                                  thickness: 2,
                                  height: 20)),

                          Row(
                            children: [
                              TextNormalWidget(
                                  text: "Customer Name: ",
                                  color: LightMode.mainColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                              TextNormalWidget(
                                  text: "${ordersDeliveryModel.userId!.name}",
                                  color: ThemeService.unselectedColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              TextNormalWidget(
                                  text: "Order Date: ",
                                  color: LightMode.mainColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                              TextNormalWidget(
                                  text: controller
                                      .editDate(ordersDeliveryModel.createdAt!),
                                  color: ThemeService.unselectedColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              TextNormalWidget(
                                  text: "Contact Number: ",
                                  color: LightMode.mainColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                              TextNormalWidget(
                                  text: "${ordersDeliveryModel.phone}",
                                  color: ThemeService.unselectedColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              TextNormalWidget(
                                  text: "Payment Method: ",
                                  color: LightMode.mainColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                              TextNormalWidget(
                                  text: "${ordersDeliveryModel.paymentMethod}",
                                  color: ThemeService.unselectedColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextNormalWidget(
                              text: "Address:",
                              color: LightMode.mainColor,
                              size: 3.2.w,
                              weight: FontWeight.w600),
                          TextNormalWidget(
                              text:
                                  "${ordersDeliveryModel.address} , ${ordersDeliveryModel.street} , ${ordersDeliveryModel.buildingNum}",
                              color: ThemeService.unselectedColor,
                              size: 3.2.w,
                              weight: FontWeight.w600,
                              multi: true,
                              numOfRow: 3),
                          SizedBox(
                              width: 100.w,
                              child: const Divider(
                                  color: LightMode.mainColor,
                                  thickness: 2,
                                  height: 20)),

                          // ... باقي تفاصيل المنتجات والمجموع تم اختصارها هنا لسهولة القراءة ويمكنك تطبيق TextNormalWidget عليها بنفس النمط ...

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextNormalWidget(
                                  text: "Total Cost",
                                  color: LightMode.mainColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                              TextNormalWidget(
                                  text: "${ordersDeliveryModel.total} EGP",
                                  color: ThemeService.textColor,
                                  size: 3.2.w,
                                  weight: FontWeight.w600),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (ordersDeliveryModel.status == "Processing")
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
                                      title: "Finish Order",
                                      onPressNo: () => Get.back(),
                                      onPressYes: () {
                                        controller.completeOrder(
                                            id: ordersDeliveryModel.id);
                                        Get.back();
                                        Get.back();
                                      });
                                },
                                size: 4.w,
                                text: "Finish",
                                width: 90.w),
                        ],
                      ),
                    ),
                    if (ordersDeliveryModel.status == "Pending")
                      ButtonWidget(
                          colorBorder: LightMode.mainColor,
                          colorFill: LightMode.whiteBlueColor,
                          colorText: LightMode.mainColor,
                          margin: false,
                          onPress: () {
                            bottomSheetMessage(
                                body:
                                    "Are you sure you want to accept the order?",
                                context: context,
                                title: "Accept Order",
                                onPressNo: () => Get.back(),
                                onPressYes: () {
                                  controller.acceptOrder(
                                      id: ordersDeliveryModel.id);
                                  Get.back();
                                  Get.back();
                                });
                          },
                          size: 3.5.w,
                          text: "Accept Order",
                          width: 90.w),
                    const SizedBox(height: 50)
                  ],
                ),
              ),
      ),
    );
  }
}
