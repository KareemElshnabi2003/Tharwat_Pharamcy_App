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

class OrdersDelivery extends StatelessWidget {
  const OrdersDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeDeliveryController());

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
              title: "Available Orders",
              colorText: LightMode.mainColor,
              colorIcon: LightMode.mainColor,
            ),
            Expanded(
              child: GetBuilder<OrdersDeliveryController>(
                builder: (controller) =>
                    FutureBuilder<List<OrdersDeliveryModel>>(
                  future: controller.availableOrdersFuture,
                  builder: (context, snapshot) {
                    return RefreshIndicator(
                      onRefresh: controller.refreshAvailableOrders,
                      color: LightMode.mainColor,
                      child: _buildContent(
                        snapshot: snapshot,
                        orders: controller.availableOrdered,
                        scrollController: controller.availableScrollController,
                        isLoadingMore: controller.isLoadingMoreAvailable,
                        emptyIcon: Icons.inbox_outlined,
                        emptyMessage: "No Available Orders",
                        orderType: 0,
                      ),
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
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return ListView(
        children: [
          SizedBox(height: 40.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text("Error loading orders",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(snapshot.error.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      );
    }

    if (orders.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 40.h),
          Center(
            child: Column(
              children: [
                Icon(emptyIcon, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(emptyMessage,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      );
    }

    return GetBuilder<OrdersDeliveryController>(
      builder: (controller) => ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 3.w, right: 5.w, left: 5.w, bottom: 3.w),
        itemBuilder: (context, index) {
          if (index < orders.length) {
            final order = orders[index];
            return OrderCardWidget(
              onPressYes: () {
                controller.acceptOrder(id: order.id);
                Get.back();
              },
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
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()))
                : const SizedBox.shrink();
          }
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: orders.length + (isLoadingMore ? 1 : 0),
      ),
    );
  }
}
