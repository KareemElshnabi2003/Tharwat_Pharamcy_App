// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tharwat_pharmacy/Core/Class/api.dart';
// import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
// import 'package:tharwat_pharmacy/Core/class/status_request.dart';
// import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
// import 'package:tharwat_pharmacy/Data/Data%20Source/Order/order_source.dart';
// import 'package:tharwat_pharmacy/Data/Model/Order/order_model.dart';
// import 'package:tharwat_pharmacy/View/Screeens/Cart/success_order.dart';
// import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/my_cart_page.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
// import 'package:tharwat_pharmacy/main.dart';

// class PaymentWebViewController extends GetxController {
//   OrderModel? orderModel;
//   String orderId = '';
//   StatuesRequest statuesRequest = StatuesRequest.none;
//   OrderRemoteData orderRemoteData = OrderRemoteData(Get.put(Api()));

//   checkStatusofPayment() async {
//     statuesRequest = StatuesRequest.loading;
//     update();
//     var response = await orderRemoteData.checkPaymentStatus(
//         orderId: orderId, token: sharedPreferences!.getString("token"));
//     print(" response ??? $response");

//     statuesRequest = handlingData(response);
//     print("orderModel data:: $orderModel");

//     if (statuesRequest == StatuesRequest.success) {
//       final responseBody = response;
//       print("response :: $responseBody");

//       if (responseBody['message'] == "messages.payment_failed") {
//         Get.snackbar("Warning!!", "Failed payment operation ....",
//             backgroundColor: LightMode.redColor,
//             borderRadius: 25,
//             padding: const EdgeInsets.all(8),
//             snackPosition: SnackPosition.BOTTOM,
//             colorText: LightMode.whiteBlueColor);
//         Get.offAll(() => const MyCartPage());
//       } else {
//         Get.snackbar("Succses!!", "Succses payment operation ....",
//             backgroundColor: LightMode.greenColor,
//             borderRadius: 25,
//             padding: const EdgeInsets.all(8),
//             snackPosition: SnackPosition.BOTTOM,
//             colorText: LightMode.blackColor);
//         print("orderModel:: $orderModel");
//         Get.to(() => SuccessOrder(
//               orderModel: orderModel!,
//             ));
//       }
//     }else {
//       messageError("Error", "There is a problem. Please,  try again later");
//     }
//     update();
//   }

//   @override
//   void onInit() {
//     orderModel = Get.arguments['orderModel'];

//     orderId = Get.arguments['orderId'] ?? '';
//     super.onInit();
//   }
// }
