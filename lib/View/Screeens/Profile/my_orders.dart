import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/my_orders_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Cart/order_details.dart';
import 'package:tharwat_pharmacy/View/Widget/MY%20Orders/order_card_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/no_data.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_click_widget.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<MyOrdersController>(
        init: MyOrdersController(),
        builder: (controller) => Column(
          children: [
            AppBarPageWidget(
                back: true,
                onPress: () => Get.back(),
                title: "My Orders",
                colorText: LightMode.mainColor,
                colorIcon: LightMode.mainColor),
            const SizedBox(height: 20),

            // Tabs
            Padding(
              padding: EdgeInsets.only(right: 5.w, left: 5.w, bottom: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTab(
                        controller: controller,
                        title: "Pending",
                        tabIndex: 0,
                        color: LightMode.greyColor),
                    SizedBox(width: 5.w),
                    _buildTab(
                        controller: controller,
                        title: "Active",
                        tabIndex: 1,
                        color: LightMode.orangeColor),
                    SizedBox(width: 5.w),
                    _buildTab(
                        controller: controller,
                        title: "Completed",
                        tabIndex: 2,
                        color: LightMode.greenColor),
                    SizedBox(width: 5.w),
                    _buildTab(
                        controller: controller,
                        title: "Canceled",
                        tabIndex: 3,
                        color: LightMode.redColor),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: 90.w,
              child: const Divider(color: LightMode.mainColor, thickness: 1),
            ),

            // Orders List
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshOrders,
                child: controller.statuesRequest == StatuesRequest.loading &&
                        controller.getCurrentOrders().isEmpty
                    ? LoadingWidget(height: 70.h)
                    : controller.getCurrentOrders().isEmpty
                        ? SingleChildScrollView(
                            controller: controller.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 70.h,
                              child: Center(
                                child: NoDataWidget(
                                  text:
                                      'No ${controller.index == 0 ? "Pending" : controller.index == 1 ? "Active" : controller.index == 2 ? "Completed" : "Canceled"} Orders',
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: controller.scrollController,
                            padding: EdgeInsets.only(
                                right: 5.w, left: 5.w, bottom: 5.w, top: 2.h),
                            itemCount: controller.getCurrentOrders().length +
                                (controller.isLoadingMore ? 1 : 0),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              if (index ==
                                  controller.getCurrentOrders().length) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: const CircularProgressIndicator(
                                        color: LightMode.mainColor),
                                  ),
                                );
                              }
                              final order =
                                  controller.getCurrentOrders()[index];
                              return OrderCardWidget(
                                date: controller.editDate(order.createdAt!),
                                index: controller.index,
                                onPressDetails: () {
                                  Get.to(() => const OrderDetails(),
                                      arguments: {"orderModel": order});
                                },
                                onPressTrack: () {},
                                orderNum: "Order #${order.id}",
                                price: "${order.total} EGP",
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      {required MyOrdersController controller,
      required String title,
      required int tabIndex,
      required Color color}) {
    final isSelected = controller.index == tabIndex;
    return Column(
      children: [
        TextClickWidget(
          text: title,
          decoration: false,
          onPress: () => controller.changeIndex(tabIndex),
          color: isSelected ? color : LightMode.mainColor,
          size: 4.w,
        ),
        const SizedBox(height: 5),
        if (isSelected)
          SizedBox(
              width: title == "Active" ? 20.w : 25.w,
              child: Divider(color: color, thickness: 4, height: 0))
        else
          const SizedBox(),
      ],
    );
  }
}
