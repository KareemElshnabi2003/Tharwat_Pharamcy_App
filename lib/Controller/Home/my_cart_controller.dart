import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Cart/cart_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Cart/cart_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class MyCartController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  CartRemoteData cartRemoteData = CartRemoteData(Get.put(Api()));
  CartModel? cartModel;
  TextEditingController couponController = TextEditingController();

  decreaseCart({required productId, required qtv}) async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await cartRemoteData.decreaseCart(
        token: sharedPreferences!.getString("token"),
        id: productId.toString(),
        qtv: qtv);

    statuesRequest = handlingData(response);
    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        // يمكنك هنا عرض رسالة نجاح إذا أردت
      },
    );
    update();
  }

  increaseCart({required productId, required qtv}) async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await cartRemoteData.increaseCart(
      token: sharedPreferences!.getString("token"),
      qtv: qtv,
      id: productId.toString(),
    );

    statuesRequest = handlingData(response);
    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {},
    );
    update();
  }

  Future<CartModel> getCartData() async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await cartRemoteData.getCartItem(
      token: sharedPreferences!.getString("token"),
    );

    statuesRequest = handlingData(response);
    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        cartModel = CartModel.fromJson(data['data']);
      },
    );
    return cartModel!;
  }

  deleteFromCart({required productId}) async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await cartRemoteData.removeFromCart(
      token: sharedPreferences!.getString("token"),
      id: productId.toString(),
    );

    statuesRequest = handlingData(response);
    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {},
    );
    update();
  }
}