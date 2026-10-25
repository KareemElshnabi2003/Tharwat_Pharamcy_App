import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data Source/Cart/cart_source.dart';
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

  void _recalculateTotal() {
    if (cartModel?.cartItems == null) return;
    double sub = 0.0;
    for (var item in cartModel!.cartItems!) {
      final price =
          double.tryParse(item.product?.itmSellPrice?.toString() ?? '0') ?? 0;
      sub += price * (item.quantity ?? 1);
    }
    cartModel!.cost = sub;
    cartModel!.totalCost = sub + (cartModel!.deliveryCost ?? 0);
  }

  Future<void> _syncCartDataSilently() async {
    try {
      var response = await cartRemoteData.getCartItem(
        token: sharedPreferences?.getString("token"),
      );
      if (handlingData(response) == StatuesRequest.success &&
          response['data'] != null) {
        cartModel = CartModel.fromJson(response['data']);
        update();
      }
    } catch (_) {}
  }

  Future<void> decreaseCart(
      {required dynamic productId, required int qtv}) async {
    if (isUpdatingCart) return;
    isUpdatingCart = true;

    // Optimistic Update: reduce quantity locally immediately
    CartItems? targetItem;
    int previousQuantity = 1;
    if (cartModel?.cartItems != null) {
      for (var item in cartModel!.cartItems!) {
        if (item.product?.id.toString() == productId.toString() ||
            item.id.toString() == productId.toString()) {
          targetItem = item;
          previousQuantity = item.quantity ?? 1;
          if (previousQuantity > 1) {
            item.quantity = previousQuantity - 1;
          }
          break;
        }
      }
      _recalculateTotal();
      update();
    }

    try {
      var response = await cartRemoteData.decreaseCart(
          token: sharedPreferences?.getString("token"),
          id: productId.toString(),
          qtv: qtv);

      final status = handlingData(response);
      if (status == StatuesRequest.success) {
        await _syncCartDataSilently();
      } else {
        // Rollback on failure
        if (targetItem != null) {
          targetItem.quantity = previousQuantity;
          _recalculateTotal();
          update();
        }
        handleApiResponse(
          status: status,
          response: response,
          onSuccess: (_) {},
        );
      }
    } catch (e) {
      if (targetItem != null) {
        targetItem.quantity = previousQuantity;
        _recalculateTotal();
        update();
      }
    } finally {
      isUpdatingCart = false;
    }
  }

  Future<void> increaseCart(
      {required dynamic productId, required int qtv}) async {
    if (isUpdatingCart) return;
    isUpdatingCart = true;

    // Optimistic Update: increment quantity locally immediately
    CartItems? targetItem;
    int previousQuantity = 1;
    if (cartModel?.cartItems != null) {
      for (var item in cartModel!.cartItems!) {
        if (item.product?.id.toString() == productId.toString() ||
            item.id.toString() == productId.toString()) {
          targetItem = item;
          previousQuantity = item.quantity ?? 1;
          item.quantity = previousQuantity + 1;
          break;
        }
      }
      _recalculateTotal();
      update();
    }

    try {
      var response = await cartRemoteData.increaseCart(
        token: sharedPreferences?.getString("token"),
        qtv: qtv,
        id: productId.toString(),
      );

      final status = handlingData(response);
      if (status == StatuesRequest.success) {
        await _syncCartDataSilently();
      } else {
        // Rollback on failure
        if (targetItem != null) {
          targetItem.quantity = previousQuantity;
          _recalculateTotal();
          update();
        }
        handleApiResponse(
          status: status,
          response: response,
          onSuccess: (_) {},
        );
      }
    } catch (e) {
      if (targetItem != null) {
        targetItem.quantity = previousQuantity;
        _recalculateTotal();
        update();
      }
    } finally {
      isUpdatingCart = false;
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
