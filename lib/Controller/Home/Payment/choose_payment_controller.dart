import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChoosePaymentController extends GetxController {
  double? totalCost;
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  String? addressValidtor(String val) => addressValidator(val);
  String? addressValidator(String val) {
    if (val.isEmpty) {
      return "Please, Enter your address ";
    } else {
      return null;
    }
  }

  String? payment;
  void choose(String? type) {
    payment = type;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      if (args['totalCost'] is num) {
        totalCost = (args['totalCost'] as num).toDouble();
      } else if (args['totalCost'] != null) {
        totalCost = double.tryParse(args['totalCost'].toString());
      }
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }
}
