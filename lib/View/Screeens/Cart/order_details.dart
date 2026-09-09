import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/my_orders_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/order_details_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/MY%20Orders/order_item_table_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderDetailsController());
    MyOrdersController myOrdersController = Get.put(MyOrdersController());

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
        myOrdersController.update();
      });
        },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<OrderDetailsController>(
          builder: (controller) => controller.statuesRequest ==
                  StatuesRequest.loading
              ? LoadingWidget(height: 100.h)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      AppBarPageWidget(
                          back: true,
                          onPress: () {
                            myOrdersController.update();
                            Get.back();
                          },
                          title: "Order Details",
                          colorText: ThemeService.isDark
                              ? LightMode.mainColor
                              : LightMode.blackColor,
                          colorIcon: ThemeService.isDark
                              ? LightMode.mainColor
                              : LightMode.blackColor),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 5.w, left: 5.w, bottom: 15.w),
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
                                    const SizedBox(width: 50)
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "#${controller.orderModel!.id}",
                                    color: ThemeService.textColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w600),
                                Row(
                                  children: [
                                    TextNormalWidget(
                                        text:
                                            "${controller.orderModel!.status}",
                                        color: controller.orderModel!.status ==
                                                "Cancelled"
                                            ? LightMode.redColor
                                            : controller.orderModel!.status ==
                                                    "Pending"
                                                ? LightMode.greyColor
                                                : controller.orderModel!
                                                            .status ==
                                                        "Completed"
                                                    ? LightMode.greenColor
                                                    : LightMode.orangeColor,
                                        size: 3.5.w,
                                        weight: FontWeight.w600),
                                    const SizedBox(width: 50)
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
                                    text: controller.orderModel!.userId?.name ??
                                        '',
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
                                    text: controller.editDate(
                                        controller.orderModel!.createdAt!),
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
                                    text: "${controller.orderModel!.phone}",
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
                                    text:
                                        "${controller.orderModel!.paymentMethod}",
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
                                    "${controller.orderModel!.address} , ${controller.orderModel!.street} , ${controller.orderModel!.buildingNum}",
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
                            OrderItemsTableWidget(
                              items: controller.orderModel!.items ?? [],
                            ),
                            const SizedBox(height: 10),
                            // (يمكنك إضافة تفاصيل أسعار المنتجات هنا بنفس النمط السابق)

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "Total",
                                    color: LightMode.mainColor,
                                    size: 3.2.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text:
                                        "${controller.orderModel!.subtotal} EGP",
                                    color: ThemeService.textColor,
                                    size: 3.2.w,
                                    weight: FontWeight.w600,
                                    multi: true,
                                    numOfRow: 3),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "Delivery",
                                    color: LightMode.mainColor,
                                    size: 3.2.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text:
                                        "${controller.orderModel!.deliveryCost} EGP",
                                    color: ThemeService.textColor,
                                    size: 3.2.w,
                                    weight: FontWeight.w600,
                                    multi: true,
                                    numOfRow: 3),
                              ],
                            ),
                            SizedBox(
                                width: 100.w,
                                child: const Divider(
                                    color: LightMode.mainColor,
                                    thickness: 2,
                                    height: 20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextNormalWidget(
                                    text: "Total Cost",
                                    color: LightMode.mainColor,
                                    size: 3.2.w,
                                    weight: FontWeight.w600),
                                TextNormalWidget(
                                    text: "${controller.orderModel!.total} EGP",
                                    color: ThemeService.textColor,
                                    size: 3.2.w,
                                    weight: FontWeight.w600,
                                    multi: true,
                                    numOfRow: 3),
                              ],
                            ),
                          ],
                        ),
                      ),
                      controller.orderModel!.status == "Cancelled" ||
                              controller.orderModel!.status == "Completed" ||
                              controller.orderModel!.status == "Processing"
                          ? const SizedBox()
                          : ButtonWidget(
                              colorBorder: LightMode.mainColor,
                              colorFill: LightMode.whiteBlueColor,
                              colorText: LightMode.mainColor,
                              margin: false,
                              onPress: () {
                                bottomSheetMessage(
                                    body:
                                        "Are you sure you want to cancel the order?",
                                    context: context,
                                    onPressNo: () => Get.back(),
                                    onPressYes: () => controller.cancelOrder(
                                        orderId: controller.orderModel!.id
                                            .toString()),
                                    title: "Canceling Order");
                              },
                              size: 3.5.w,
                              text: "Cancel Order",
                              width: 90.w),
                      const SizedBox(height: 50)
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
