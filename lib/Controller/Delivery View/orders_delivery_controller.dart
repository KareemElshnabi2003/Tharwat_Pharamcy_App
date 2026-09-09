import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Order/order_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/ordeers_delivery_model.dart';

class OrdersDeliveryController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  OrderRemoteData orderRemoteData = OrderRemoteData(Get.put(Api()));

  List<OrdersDeliveryModel> completeOrdered = [];
  List<OrdersDeliveryModel> myOrdered = [];
  List<OrdersDeliveryModel> availableOrdered = [];

  int completedCurrentPage = 1;
  int myOrdersCurrentPage = 1;
  int availableCurrentPage = 1;

  bool hasMoreCompletedOrders = true;
  bool hasMoreMyOrders = true;
  bool hasMoreAvailableOrders = true;

  bool isLoadingMoreCompleted = false;
  bool isLoadingMoreMyOrders = false;
  bool isLoadingMoreAvailable = false;

  ScrollController completedScrollController = ScrollController();
  ScrollController myOrdersScrollController = ScrollController();
  ScrollController availableScrollController = ScrollController();

  late Future<List<OrdersDeliveryModel>> completedOrdersFuture;
  late Future<List<OrdersDeliveryModel>> myOrdersFuture;
  late Future<List<OrdersDeliveryModel>> availableOrdersFuture;

  @override
  void onInit() {
    super.onInit();
    completedOrdersFuture = fetchCompletedOrders();
    myOrdersFuture = fetchMyOrders();
    availableOrdersFuture = fetchAvailableOrders();
    _setupScrollListeners();
  }

  @override
  void onClose() {
    completedScrollController.dispose();
    myOrdersScrollController.dispose();
    availableScrollController.dispose();
    super.onClose();
  }

  void _setupScrollListeners() {
    completedScrollController.addListener(() {
      if (completedScrollController.position.pixels >=
              completedScrollController.position.maxScrollExtent * 0.8 &&
          !isLoadingMoreCompleted &&
          hasMoreCompletedOrders) {
        loadMoreCompletedOrders();
      }
    });
    myOrdersScrollController.addListener(() {
      if (myOrdersScrollController.position.pixels >=
              myOrdersScrollController.position.maxScrollExtent * 0.8 &&
          !isLoadingMoreMyOrders &&
          hasMoreMyOrders) {
        loadMoreMyOrders();
      }
    });
    availableScrollController.addListener(() {
      if (availableScrollController.position.pixels >=
              availableScrollController.position.maxScrollExtent * 0.8 &&
          !isLoadingMoreAvailable &&
          hasMoreAvailableOrders) {
        loadMoreAvailableOrders();
      }
    });
  }

  acceptOrder({required id}) async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await orderRemoteData.acceptOrder(id: id);
    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        Get.snackbar("Success", "The order is accepted successfully.",
            borderRadius: 25,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        refreshAvailableOrders();
        refreshMyOrders();
      },
    );
    update();
  }

  completeOrder({required id}) async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await orderRemoteData.updateOrder(id: id);
    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        Get.snackbar("Success", "The order is completed successfully.",
            borderRadius: 25,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.back();
        refreshMyOrders();
        refreshCompletedOrders();
      },
    );
    update();
  }

  String editDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${DateFormat('dd MMM').format(dateTime)} / ${DateFormat('h:mm a').format(dateTime)}";
  }

  // ==================== COMPLETED ORDERS ====================
  Future<List<OrdersDeliveryModel>> fetchCompletedOrders({int page = 1}) async {
    try {
      var response =
          await orderRemoteData.getCompletedDeliveryOrders(page: page);
      var status = handlingData(response);

      if (status == StatuesRequest.success) {
        List responseBody = response['data'];
        if (page == 1) {
          completeOrdered = responseBody
              .map((e) => OrdersDeliveryModel.fromJson(e))
              .where((e) => e.status == "Completed")
              .toList();
          completedCurrentPage = 1;
          hasMoreCompletedOrders = responseBody.length >= 10;
        }
      }
      return completeOrdered;
    } catch (e) {
      if (page == 1) completeOrdered = [];
      return completeOrdered;
    }
  }

  Future<List<OrdersDeliveryModel>> refreshCompletedOrders() async {
    completedCurrentPage = 1;
    hasMoreCompletedOrders = true;
    completedOrdersFuture = fetchCompletedOrders();
    update();
    return completedOrdersFuture;
  }

  Future<void> loadMoreCompletedOrders() async {
    if (isLoadingMoreCompleted || !hasMoreCompletedOrders) return;
    isLoadingMoreCompleted = true;
    update();

    completedCurrentPage++;
    var response = await orderRemoteData.getCompletedDeliveryOrders(
        page: completedCurrentPage);
    var status = handlingData(response);

    if (status == StatuesRequest.success) {
      List responseBody = response['data'];
      if (responseBody.isEmpty) {
        hasMoreCompletedOrders = false;
      } else {
        List<OrdersDeliveryModel> newOrders = responseBody
            .map((e) => OrdersDeliveryModel.fromJson(e))
            .where((e) => e.status == "Completed")
            .toList();
        completeOrdered.addAll(newOrders);
        hasMoreCompletedOrders = responseBody.length >= 10;
      }
    } else {
      completedCurrentPage--;
    }
    isLoadingMoreCompleted = false;
    update();
  }

  // ==================== AVAILABLE ORDERS ====================
  Future<List<OrdersDeliveryModel>> fetchAvailableOrders({int page = 1}) async {
    try {
      var response = await orderRemoteData.getPendingDeliveryOrders(page: page);
      var status = handlingData(response);

      if (status == StatuesRequest.success) {
        List responseBody = response['data'];
        if (page == 1) {
          availableOrdered = responseBody
              .map((e) => OrdersDeliveryModel.fromJson(e))
              .where((e) => e.status == "Pending")
              .toList();
          availableCurrentPage = 1;
          hasMoreAvailableOrders = responseBody.length >= 10;
        }
      }
      return availableOrdered;
    } catch (e) {
      if (page == 1) availableOrdered = [];
      return availableOrdered;
    }
  }

  Future<List<OrdersDeliveryModel>> refreshAvailableOrders() async {
    availableCurrentPage = 1;
    hasMoreAvailableOrders = true;
    availableOrdersFuture = fetchAvailableOrders();
    update();
    return availableOrdersFuture;
  }

  Future<void> loadMoreAvailableOrders() async {
    if (isLoadingMoreAvailable || !hasMoreAvailableOrders) return;
    isLoadingMoreAvailable = true;
    update();

    availableCurrentPage++;
    var response = await orderRemoteData.getPendingDeliveryOrders(
        page: availableCurrentPage);
    var status = handlingData(response);

    if (status == StatuesRequest.success) {
      List responseBody = response['data'];
      if (responseBody.isEmpty) {
        hasMoreAvailableOrders = false;
      } else {
        List<OrdersDeliveryModel> newOrders = responseBody
            .map((e) => OrdersDeliveryModel.fromJson(e))
            .where((e) => e.status == "Pending")
            .toList();
        availableOrdered.addAll(newOrders);
        hasMoreAvailableOrders = responseBody.length >= 10;
      }
    } else {
      availableCurrentPage--;
    }
    isLoadingMoreAvailable = false;
    update();
  }

  // ==================== MY ORDERS ====================
  Future<List<OrdersDeliveryModel>> fetchMyOrders({int page = 1}) async {
    try {
      var response = await orderRemoteData.getMyOrderDelivery(page: page);
      var status = handlingData(response);

      if (status == StatuesRequest.success) {
        List responseBody = response['data'];
        if (page == 1) {
          myOrdered = responseBody
              .map((e) => OrdersDeliveryModel.fromJson(e))
              .where((e) => e.status == "Processing")
              .toList();
          myOrdersCurrentPage = 1;
          hasMoreMyOrders = responseBody.length >= 10;
        }
      }
      return myOrdered;
    } catch (e) {
      if (page == 1) myOrdered = [];
      return myOrdered;
    }
  }

  Future<List<OrdersDeliveryModel>> refreshMyOrders() async {
    myOrdersCurrentPage = 1;
    hasMoreMyOrders = true;
    myOrdersFuture = fetchMyOrders();
    update();
    return myOrdersFuture;
  }

  Future<void> loadMoreMyOrders() async {
    if (isLoadingMoreMyOrders || !hasMoreMyOrders) return;
    isLoadingMoreMyOrders = true;
    update();

    myOrdersCurrentPage++;
    var response =
        await orderRemoteData.getMyOrderDelivery(page: myOrdersCurrentPage);
    var status = handlingData(response);

    if (status == StatuesRequest.success) {
      List responseBody = response['data'];
      if (responseBody.isEmpty) {
        hasMoreMyOrders = false;
      } else {
        List<OrdersDeliveryModel> newOrders = responseBody
            .map((e) => OrdersDeliveryModel.fromJson(e))
            .where((e) => e.status == "Processing")
            .toList();
        myOrdered.addAll(newOrders);
        hasMoreMyOrders = responseBody.length >= 10;
      }
    } else {
      myOrdersCurrentPage--;
    }
    isLoadingMoreMyOrders = false;
    update();
  }
}
