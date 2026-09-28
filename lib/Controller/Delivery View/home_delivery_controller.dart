import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/completed_orders_delivery.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/my_orders_delivery.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/orders_delivery.dart';

class HomeDeliveryController extends GetxController {
  int currentIndex = 0;

  bool choose_1 = false;
  bool choose_2 = false;
  bool choose_3 = false;

  void _syncChoose(int index) {
    choose_1 = index == 0;
    choose_2 = index == 1;
    choose_3 = index == 2;
  }

  void change_1() {
    currentIndex = 0;
    _syncChoose(0);
    update();
  }

  void change_2() {
    currentIndex = 1;
    _syncChoose(1);
    update();
  }

  void change_3() {
    currentIndex = 2;
    _syncChoose(2);
    update();
  }

  List<Widget> pages = [
    const OrdersDelivery(),
    const MyOrdersDelivery(),
    const CompletedOrdersDelivery(),
  ];

  void changePage(int pageIndex, {String name = "", String id = ""}) {
    currentIndex = pageIndex;
    _syncChoose(pageIndex);
    update();
  }

  @override
  void onInit() {
    _syncChoose(currentIndex);
    super.onInit();
  }
}
