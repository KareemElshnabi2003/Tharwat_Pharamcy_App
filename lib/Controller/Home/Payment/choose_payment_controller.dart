import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChoosePaymentController extends GetxController {
  double? totalCost;
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> addressKey = GlobalKey();
  addressValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your address ";
    } else {
      return null;
    }
  }

  String? payment;
  choose(type) {
    payment = type;

    update();
  }

  @override
  void onInit() {
    totalCost = Get.arguments["totalCost"];
    super.onInit();
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }
}
