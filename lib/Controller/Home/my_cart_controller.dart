import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Cart/cart_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Cart/cart_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class MyCartController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  CartRemoteData cartRemoteData = CartRemoteData(Get.find<Api>());
  CartModel? cartModel;
  TextEditingController couponController = TextEditingController();

  Future<CartModel?>? cartDataFuture;
  bool isLoadingCart = false;
  bool isUpdatingCart = false;

  @override
  void onInit() {
    super.onInit();
    cartDataFuture = getCartData();
  }

  Future<void> refreshCart() async {
    cartDataFuture = getCartData();
    await cartDataFuture;
    update();
  }

  Future<void> decreaseCart(
      {required dynamic productId, required int qtv}) async {
    if (isUpdatingCart) return;
    isUpdatingCart = true;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await cartRemoteData.decreaseCart(
          token: sharedPreferences?.getString("token"),
          id: productId.toString(),
          qtv: qtv);

      statuesRequest = handlingData(response);
      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {},
      );
      cartDataFuture = getCartData();
      await cartDataFuture;
    } finally {
      isUpdatingCart = false;
      update();
    }
  }

  Future<void> increaseCart(
      {required dynamic productId, required int qtv}) async {
    if (isUpdatingCart) return;
    isUpdatingCart = true;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await cartRemoteData.increaseCart(
        token: sharedPreferences?.getString("token"),
        qtv: qtv,
        id: productId.toString(),
      );

      statuesRequest = handlingData(response);
      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {},
      );
      cartDataFuture = getCartData();
      await cartDataFuture;
    } finally {
      isUpdatingCart = false;
      update();
    }
  }

  Future<CartModel?> getCartData() async {
    if (isLoadingCart) return cartModel;
    isLoadingCart = true;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await cartRemoteData.getCartItem(
        token: sharedPreferences?.getString("token"),
      );

      statuesRequest = handlingData(response);
      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          if (data['data'] != null) {
            cartModel = CartModel.fromJson(data['data']);
          }
        },
      );
      return cartModel;
    } catch (e) {
      statuesRequest = handleException(e);
      return null;
    } finally {
      isLoadingCart = false;
      update();
    }
  }

  Future<void> deleteFromCart({required productId}) async {
    if (isUpdatingCart) return;
    isUpdatingCart = true;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await cartRemoteData.removeFromCart(
        token: sharedPreferences?.getString("token"),
        id: productId.toString(),
      );

      statuesRequest = handlingData(response);
      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {},
      );
      cartDataFuture = getCartData();
      await cartDataFuture;
    } finally {
      isUpdatingCart = false;
      update();
    }
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
