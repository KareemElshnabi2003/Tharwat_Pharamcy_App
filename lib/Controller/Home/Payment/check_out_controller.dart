import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Order/order_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/order_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Cart/success_order.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class CheckOutController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  OrderRemoteData orderRemoteData = OrderRemoteData(Get.find<Api>());
  OrderModel? orderModel;
  GlobalKey<FormState> checkKey = GlobalKey<FormState>();

  TextEditingController buildingController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController additionalInfoController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String paymentMethod = '';
  double? totalCost;
  String timeOnly = '';
  String dateOnly = '';

  String? phoneValidtor(String val) => phoneValidator(val);
  String? phoneValidator(String val) {
    if (!val.isPhoneNumber) {
      return "Please, Enter your phone ";
    } else {
      return null;
    }
  }

  String? streetValidtor(String val) => streetValidator(val);
  String? streetValidator(String val) {
    if (val.length < 15) {
      return "Please, Enter your street in detail ";
    } else {
      return null;
    }
  }

  String? addressValidtor(String val) => addressValidator(val);
  String? addressValidator(String val) {
    if (val.length < 20) {
      return "Please, Enter your address in detail ";
    } else {
      return null;
    }
  }

  String? buildingValidtor(String val) => buildingValidator(val);
  String? buildingValidator(String val) {
    if (val.isEmpty) {
      return "Please, Enter your building ";
    } else {
      return null;
    }
  }

  String? additionalInfoValidtor(String val) => additionalInfoValidator(val);
  String? additionalInfoValidator(String val) {
    if (val.isEmpty) {
      return "Please, Enter your info ";
    } else {
      return null;
    }
  }

  Future<void> createOrder() => craeteOrder();
  Future<void> craeteOrder() async {
    if (!checkKey.currentState!.validate()) {
      return;
    }

    final cityIdStr = sharedPreferences?.getString("cityId");
    final countryIdStr = sharedPreferences?.getString("countryId");
    final districtIdStr = sharedPreferences?.getString("districtId");
    final cityId = int.tryParse(cityIdStr ?? '');
    final countryId = int.tryParse(countryIdStr ?? '');
    final districtId = int.tryParse(districtIdStr ?? '');

    if (cityId == null || countryId == null || districtId == null) {
      messageError("Error", "Please select your location / address first");
      return;
    }

    try {
      statuesRequest = StatuesRequest.loading;
      update();

      var response = await orderRemoteData.createOrder(
          additionalInfo: additionalInfoController.text,
          address: addressController.text,
          buildingNum: buildingController.text,
          cityId: cityId,
          countryId: countryId,
          districtId: districtId,
          payment: paymentMethod == ""
              ? "instapay"
              : paymentMethod == "credit / debit card"
                  ? "card"
                  : paymentMethod == "vodafone cash"
                      ? "vfCash"
                      : "cash",
          phone: phoneController.text,
          street: streetController.text,
          total: totalCost,
          token: sharedPreferences?.getString("token"));

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        final responseBody = response["data"];

        orderModel = OrderModel.fromJson(responseBody);

        Get.to(() => SuccessOrder(
              orderModel: orderModel!,
            ));
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", "please enter all fields");
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "There is a problem. Please, try again later");
    } finally {
      if (statuesRequest == StatuesRequest.loading) {
        statuesRequest = StatuesRequest.none;
      }
      update();
    }
  }

  String editDate(dynamic date) {
    if (date == null || date.toString().isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(date.toString());
      dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);
      return dateOnly;
    } catch (_) {
      return date.toString();
    }
  }

  String edittime(dynamic date) => editTime(date);
  String editTime(dynamic date) {
    if (date == null || date.toString().isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(date.toString());
      dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);
      timeOnly = DateFormat('h:mm a').format(dateTime);
      return timeOnly;
    } catch (_) {
      return date.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      paymentMethod = args['payment']?.toString() ?? "";
      if (args['totalCost'] is num) {
        totalCost = (args['totalCost'] as num).toDouble();
      } else if (args['totalCost'] != null) {
        totalCost = double.tryParse(args['totalCost'].toString());
      }
    }
  }

  @override
  void onClose() {
    buildingController.dispose();
    addressController.dispose();
    streetController.dispose();
    additionalInfoController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
