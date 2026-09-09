import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Order/order_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/order_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Cart/success_order.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class CheckOutController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  OrderRemoteData orderRemoteData = OrderRemoteData(Get.put(Api()));
  OrderModel? orderModel;
  GlobalKey<FormState> checkKey = GlobalKey();

  TextEditingController buildingController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController additionalInfoController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String paymentMethod = '';
  double? totalCost;
  String timeOnly = '';
  String dateOnly = '';
  phoneValidtor(String val) {
    if (!val.isPhoneNumber) {
      return "Please, Enter your phone ";
    } else {
      return null;
    }
  }

  streetValidtor(String val) {
    if (val.length < 15) {
      return "Please, Enter your street in detail ";
    } else {
      return null;
    }
  }

  addressValidtor(String val) {
    if (val.length < 20) {
      return "Please, Enter your address in detail ";
    } else {
      return null;
    }
  }

  buildingValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your building ";
    } else {
      return null;
    }
  }

  additionalInfoValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your info ";
    } else {
      return null;
    }
  }

  craeteOrder() async {
    if (checkKey.currentState!.validate()) {
      print(paymentMethod);
      statuesRequest = StatuesRequest.loading;
      update();

      var response = await orderRemoteData.createOrder(
          additionalInfo: additionalInfoController.text,
          address: addressController.text,
          buildingNum: buildingController.text,
          cityId: int.parse(sharedPreferences!.getString("cityId")!),
          countryId: int.parse(sharedPreferences!.getString("countryId")!),
          districtId: int.parse(sharedPreferences!.getString("districtId")!),
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
          token: sharedPreferences!.getString("token"));

      print(" response ??? $response");

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        final responseBody = response["data"];
        print("response :: $responseBody");

        orderModel = OrderModel.fromJson(responseBody);

        print("succses order");

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
    }
    update();
  }

  editDate(date) {
    DateTime dateTime = DateTime.parse(date);
    dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);

    return dateOnly;
  }

  edittime(date) {
    DateTime dateTime = DateTime.parse(date);
    dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);
    timeOnly = DateFormat('h:mm a').format(dateTime);
    return timeOnly;
  }

  @override
  void onInit() {
    paymentMethod = Get.arguments['payment'] ?? "";

    totalCost = Get.arguments['totalCost'] ?? 0;
    super.onInit();
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
