import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Delivery%20View/home_delivery_controller.dart';
import 'package:tharwat_pharmacy/Controller/Delivery%20View/orders_delivery_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/ordeers_delivery_model.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/order_details_delivery.dart';
import 'package:tharwat_pharmacy/View/Widget/MY%20Orders/order_card_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';

class CompletedOrdersDelivery extends StatelessWidget {
  const CompletedOrdersDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeDeliveryController>()
        ? Get.find<HomeDeliveryController>()
        : Get.put(HomeDeliveryController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeController.changePage(0);
          homeController.choose_1 = true;
          homeController.choose_2 = false;
        });
      },
      child: Scaffold(
        backgroundColor: LightMode.whiteColor,
        body: Column(
          children: [
            AppBarPageWidget(
              back: true,
              onPress: () {
                homeController.changePage(0);
                homeController.choose_1 = true;
                homeController.choose_2 = false;
              },
              title: "Completed Orders",
              colorText: LightMode.mainColor,
              colorIcon: LightMode.mainColor,
            ),
            Expanded(
              child: GetBuilder<OrdersDeliveryController>(
                init: OrdersDeliveryController(),
                builder: (controller) =>
                    FutureBuilder<List<OrdersDeliveryModel>>(
                  future: controller.completedOrdersFuture,
                  builder: (context, snapshot) {
                    return RefreshIndicator(
                      onRefresh: controller.refreshCompletedOrders,
                      color: LightMode.mainColor,
                      child: _buildContent(
                          snapshot: snapshot,
                          orders: controller.completeOrdered,
                          scrollController:
                              controller.completedScrollController,
                          isLoadingMore: controller.isLoadingMoreCompleted,
                          emptyIcon: Icons.inbox_outlined,
                          emptyMessage: "No Completed Orders",
                          orderType: 2,
                          controller: controller),
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

  Widget _buildContent({
    required AsyncSnapshot<List<OrdersDeliveryModel>> snapshot,
    required List<OrdersDeliveryModel> orders,
    required ScrollController scrollController,
    required bool isLoadingMore,
    required IconData emptyIcon,
    required String emptyMessage,
    required int orderType,
    required OrdersDeliveryController controller,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return const Center(child: Text("Error loading orders"));
    }
    if (orders.isEmpty) return Center(child: Text(emptyMessage));

    return ListView.separated(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 3.w, right: 5.w, left: 5.w, bottom: 3.w),
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];
          return OrderCardWidget(
            onPressYes: () {},
            status: orderType == 0
                ? "active"
                : orderType == 1
                    ? "finsh"
                    : "none",
            date: controller.editDate(order.createdAt!),
            index: orderType,
            delivery: true,
            onPressDetails: () {
              Get.to(() => OrderDetailsDelivery(ordersDeliveryModel: order));
            },
            orderNum: "#${order.id}",
            price: "${order.total} EGP",
          );
        } else {
          return isLoadingMore
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: orders.length + (isLoadingMore ? 1 : 0),
    );
  }
}
