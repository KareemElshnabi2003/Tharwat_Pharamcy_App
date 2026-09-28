import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Order/order_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/my_order_model.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class OrderDetailsController extends GetxController {
  MyOrderModel? orderModel;
  StatuesRequest statuesRequest = StatuesRequest.none;
  OrderRemoteData orderRemoteData = OrderRemoteData(Get.find<Api>());

  String editDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${DateFormat('dd MMM').format(dateTime)} / ${DateFormat('h:mm a').format(dateTime)}";
  }

  Future<void> cancelOrder({required dynamic orderId}) async {
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await orderRemoteData.cancelOrder(
          id: orderId.toString(), token: sharedPreferences?.getString("token"));

      statuesRequest = handlingData(response);
      if (statuesRequest == StatuesRequest.success) {
        final responseBody = response['data'];
        if (orderModel != null &&
            responseBody is Map &&
            responseBody['status'] != null) {
          orderModel!.status = responseBody['status'];
        }
        Get.back();
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = StatuesRequest.serverError;
      messageError("Error", "There is a problem. Please,  try again later");
    } finally {
      if (statuesRequest == StatuesRequest.loading) {
        statuesRequest = StatuesRequest.none;
      }
      update();
    }
  }

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map && args['orderModel'] is MyOrderModel) {
      orderModel = args['orderModel'] as MyOrderModel;
    } else if (args is MyOrderModel) {
      orderModel = args;
    }
    super.onInit();
  }
}
