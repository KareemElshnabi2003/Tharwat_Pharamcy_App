import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Class/status_request.dart';
import 'package:tharwat_pharmacy/Core/Services/session_service.dart';
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

  // Debounce timers per item ID to prevent rapid tap race conditions
  final Map<String, Timer> _debounceTimers = {};
  final Map<String, int> _originalQuantities = {};

  String? get _token => Get.isRegistered<SessionService>()
      ? SessionService.to.token
      : sharedPreferences?.getString("token");

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
    if (cartModel == null) return;
    if (cartModel!.cartItems == null || cartModel!.cartItems!.isEmpty) {
      cartModel!.cost = 0.0;
      cartModel!.totalCost = 0.0;
      return;
    }
    double sub = 0.0;
    for (var item in cartModel!.cartItems!) {
      final price =
          double.tryParse(item.product?.itmSellPrice?.toString() ?? '0') ?? 0.0;
      sub += price * (item.quantity ?? 1);
    }
    cartModel!.cost = double.parse(sub.toStringAsFixed(2));
    final delivery = cartModel!.deliveryCost ?? 0.0;
    cartModel!.totalCost = double.parse((sub + delivery).toStringAsFixed(2));
  }

  Future<void> _syncCartDataSilently() async {
    try {
      var response = await cartRemoteData.getCartItem(token: _token);
      if (handlingData(response) == StatuesRequest.success &&
          response['data'] != null) {
        cartModel = CartModel.fromJson(response['data']);
        _recalculateTotal();
        update();
      }
    } catch (_) {}
  }

  CartItems? _findItem(dynamic id) {
    if (cartModel?.cartItems == null) return null;
    final strId = id.toString();
    for (var item in cartModel!.cartItems!) {
      if (item.id?.toString() == strId ||
          item.product?.id?.toString() == strId) {
        return item;
      }
    }
    return null;
  }

  void increaseCart({required dynamic productId, int? qtv}) {
    final item = _findItem(productId);
    if (item == null) return;

    final key = item.id.toString();
    _originalQuantities.putIfAbsent(key, () => item.quantity ?? 1);

    // Optimistic Update: Increment instantly in UI
    item.quantity = (item.quantity ?? 1) + 1;
    _recalculateTotal();
    update();

    // Debounce the network request by 350ms
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(const Duration(milliseconds: 350), () async {
      final targetQtv = item.quantity ?? 1;
      try {
        var response = await cartRemoteData.increaseCart(
          token: _token,
          id: item.id.toString(),
          qtv: targetQtv,
        );

        final status = handlingData(response);
        if (status == StatuesRequest.success) {
          _originalQuantities.remove(key);
          await _syncCartDataSilently();
        } else {
          // Rollback on failure
          item.quantity = _originalQuantities[key] ?? targetQtv;
          _originalQuantities.remove(key);
          _recalculateTotal();
          update();
          handleApiResponse(
            status: status,
            response: response,
            onSuccess: (_) {},
          );
        }
      } catch (e) {
        item.quantity = _originalQuantities[key] ?? targetQtv;
        _originalQuantities.remove(key);
        _recalculateTotal();
        update();
      }
    });
  }

  void decreaseCart({required dynamic productId, int? qtv}) {
    final item = _findItem(productId);
    if (item == null) return;

    final key = item.id.toString();
    _originalQuantities.putIfAbsent(key, () => item.quantity ?? 1);

    if ((item.quantity ?? 1) <= 1) {
      deleteFromCart(productId: item.id);
      return;
    }

    // Optimistic Update: Decrement instantly in UI
    item.quantity = (item.quantity ?? 1) - 1;
    _recalculateTotal();
    update();

    // Debounce the network request by 350ms
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(const Duration(milliseconds: 350), () async {
      final targetQtv = item.quantity ?? 1;
      try {
        var response = await cartRemoteData.decreaseCart(
          token: _token,
          id: item.id.toString(),
          qtv: targetQtv,
        );

        final status = handlingData(response);
        if (status == StatuesRequest.success) {
          _originalQuantities.remove(key);
          await _syncCartDataSilently();
        } else {
          // Rollback on failure
          item.quantity = _originalQuantities[key] ?? targetQtv;
          _originalQuantities.remove(key);
          _recalculateTotal();
          update();
          handleApiResponse(
            status: status,
            response: response,
            onSuccess: (_) {},
          );
        }
      } catch (e) {
        item.quantity = _originalQuantities[key] ?? targetQtv;
        _originalQuantities.remove(key);
        _recalculateTotal();
        update();
      }
    });
  }

  Future<void> deleteFromCart({required dynamic productId}) async {
    final item = _findItem(productId);
    if (item == null) return;

    final key = item.id.toString();
    _debounceTimers[key]?.cancel();
    _debounceTimers.remove(key);

    // Optimistic deletion
    final originalIndex = cartModel?.cartItems?.indexOf(item) ?? -1;
    cartModel?.cartItems?.remove(item);
    _recalculateTotal();
    update();

    try {
      var response = await cartRemoteData.removeFromCart(
        token: _token,
        id: item.id.toString(),
      );

      final status = handlingData(response);
      if (status == StatuesRequest.success) {
        await _syncCartDataSilently();
      } else {
        // Rollback on failure
        if (originalIndex >= 0 && cartModel?.cartItems != null) {
          cartModel!.cartItems!.insert(originalIndex, item);
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
      if (originalIndex >= 0 && cartModel?.cartItems != null) {
        cartModel!.cartItems!.insert(originalIndex, item);
        _recalculateTotal();
        update();
      }
    }
  }

  Future<CartModel?> getCartData() async {
    if (isLoadingCart) return cartModel;
    isLoadingCart = true;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await cartRemoteData.getCartItem(token: _token);

      statuesRequest = handlingData(response);
      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          if (data['data'] != null) {
            cartModel = CartModel.fromJson(data['data']);
            _recalculateTotal();
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

  @override
  void onClose() {
    for (var timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    couponController.dispose();
    super.onClose();
  }
}
