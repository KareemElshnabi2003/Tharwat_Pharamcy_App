import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Order/order_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/my_order_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class MyOrdersController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  OrderRemoteData orderRemoteData = OrderRemoteData(Get.put(Api()));

  List<MyOrderModel> completeOrdered = [];
  List<MyOrderModel> cancelOrdered = [];
  List<MyOrderModel> activeOrdered = [];
  List<MyOrderModel> pendingOrdered = [];

  bool hasMoreData = true;
  bool isLoadingMore = false;
  int currentPage = 1;
  int lastPage = 1;

  ScrollController scrollController = ScrollController();
  int index = 0;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    loadInitialOrders();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && hasMoreData && statuesRequest == StatuesRequest.success) {
        loadMoreOrders();
      }
    }
  }

  String editDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${DateFormat('dd MMM').format(dateTime)} / ${DateFormat('h:mm a').format(dateTime)}";
  }

  changeIndex(int i) {
    index = i;
    resetPagination();
    loadInitialOrders();
  }

  void resetPagination() {
    currentPage = 1;
    hasMoreData = true;
    isLoadingMore = false;

    if (index == 0) pendingOrdered.clear();
    else if (index == 1) activeOrdered.clear();
    else if (index == 2) completeOrdered.clear();
    else cancelOrdered.clear();
  }

  Future<void> loadInitialOrders() async {
    resetPagination();
    await _fetchOrders();
  }

  Future<void> loadMoreOrders() async {
    if (isLoadingMore || !hasMoreData || currentPage >= lastPage) return;
    isLoadingMore = true;
    update();
    currentPage++;
    await _fetchOrders();
    isLoadingMore = false;
    update();
  }

  Future<void> refreshOrders() async {
    resetPagination();
    await _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (currentPage == 1) {
      statuesRequest = StatuesRequest.loading;
      update();
    }

    String token = sharedPreferences!.getString("token") ?? "";
    dynamic response;

    if (index == 0) response = await orderRemoteData.getPendingOrder(token: token, page: currentPage);
    else if (index == 1) response = await orderRemoteData.getActiveOrder(token: token, page: currentPage);
    else if (index == 2) response = await orderRemoteData.getCompleteOrder(token: token, page: currentPage);
    else response = await orderRemoteData.getCanceledOrder(token: token, page: currentPage);

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        lastPage = data['pagination']['last_page'];
        List<MyOrderModel> newOrders = (data['data'] as List).map((e) => MyOrderModel.fromJson(e)).toList();

        if (index == 0) {
          currentPage == 1 ? pendingOrdered = newOrders : pendingOrdered.addAll(newOrders);
        } else if (index == 1) {
          currentPage == 1 ? activeOrdered = newOrders : activeOrdered.addAll(newOrders);
        } else if (index == 2) {
          currentPage == 1 ? completeOrdered = newOrders : completeOrdered.addAll(newOrders);
        } else {
          currentPage == 1 ? cancelOrdered = newOrders : cancelOrdered.addAll(newOrders);
        }

        hasMoreData = currentPage < lastPage;
      },
    );

    if (statuesRequest != StatuesRequest.success && currentPage > 1) {
      currentPage--;
    }
    update();
  }

  List<MyOrderModel> getCurrentOrders() {
    if (index == 0) return pendingOrdered;
    if (index == 1) return activeOrdered;
    if (index == 2) return completeOrdered;
    return cancelOrdered;
  }
}