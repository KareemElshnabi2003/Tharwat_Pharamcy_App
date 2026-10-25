import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/payment_method.dart';

class ChoosePaymentController extends GetxController {
  double? totalCost;
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> addressKey = GlobalKey<FormState>();

  String? addressValidator(String val) {
    if (val.trim().isEmpty) {
      return "Please, Enter your address";
    }
    return null;
  }

  String? addressValidtor(String val) => addressValidator(val);

  String? payment;
  PaymentMethod? get paymentMethod => PaymentMethod.fromDisplayName(payment);

  void choose(dynamic type) {
    if (type is PaymentMethod) {
      payment = type.displayName;
    } else {
      payment = type?.toString();
    }
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
