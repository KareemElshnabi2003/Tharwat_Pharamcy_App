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
  OrderRemoteData orderRemoteData = OrderRemoteData(Get.put(Api()));

  editDate(date) {
    DateTime dateTime = DateTime.parse(date);

    return "${DateFormat('dd MMM').format(dateTime)} / ${DateFormat('h:mm a').format(dateTime)}";
  }

  cancelOrder({orderId}) async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await orderRemoteData.cancelOrder(
        id: orderId.toString(), token: sharedPreferences!.getString("token"));
    print(" response ??? $response");

    statuesRequest = handlingData(response);
    if (statuesRequest == StatuesRequest.success) {
      final responseBody = response['data'];
      print("response :: $responseBody");
      orderModel!.status = responseBody['status'];

      Get.back();
    }else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
      messageError("Error", "There is a problem. Please,  try again later");
    }
    update();
  }

  @override
  void onInit() {
    orderModel = Get.arguments['orderModel'];

    super.onInit();
  }
}
