import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/favourite_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class FavouriteController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  FavouriteRemoteData favouriteRemoteData = FavouriteRemoteData(Get.put(Api()));

  List<ProductModel> favItems = [];
  final Set<dynamic> favProductsId = <dynamic>{};

  bool choose_1 = true;
  bool choose_2 = false;

  // Pagination variables
  int currentPage = 1;
  bool hasMoreData = true;
  bool isLoadingMore = false;
  bool isLoadingFav = false;
  Future<List<ProductModel>>? favItemsFuture;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    favItemsFuture = getFavItems();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore &&
          hasMoreData &&
          statuesRequest == StatuesRequest.success) {
        loadMoreFavItems();
      }
    }
  }

  void resetPagination() {
    currentPage = 1;
    hasMoreData = true;
    favItems.clear();
  }

  Future<void> favProducts(dynamic id) async {
    favProductsId.add(id);
    update(['fav_$id']);
    await addItemToFav(id);
  }

  Future<void> notFavProducts(dynamic id) async {
    favProductsId.remove(id);
    favItems.removeWhere((item) => item.id.toString() == id.toString());
    update(['fav_$id']);
    await removeItemFromFav(id);
  }

  change_1() {
    choose_1 = true;
    choose_2 = false;
    update();
  }

  change_2() {
    choose_1 = false;
    choose_2 = true;
    update();
  }

  // Initial load
  Future<List<ProductModel>> getFavItems() async {
    if (isLoadingFav) return favItems;
    isLoadingFav = true;
    try {
      if (currentPage == 1) {
        favItems.clear();
        statuesRequest = StatuesRequest.loading;
        update();
      }

      var response = await favouriteRemoteData.getFavProducts(
        token: sharedPreferences?.getString("token"),
        page: currentPage,
      );

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;

        List<ProductModel> newItems = (responseBody['data'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();

        if (currentPage == 1) {
          favItems = newItems;
        } else {
          favItems.addAll(newItems);
        }

        // Check if there's more data (assuming less than 20 items means no more data)
        if (newItems.isEmpty || newItems.length < 20) {
          hasMoreData = false;
        }
      } else if (statuesRequest == StatuesRequest.unauthorizedException) {
        messageErrorWithButton("Error", "You need to login ", () {
          Get.offAll(() => const LoginPage());
        }, "LogIn");
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please, try again later");
      }

      return favItems;
    } finally {
      isLoadingFav = false;
      update();
    }
  }

  // Load more for pagination
  Future<void> loadMoreFavItems() async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    update();

    try {
      currentPage++;

      var response = await favouriteRemoteData.getFavProducts(
        token: sharedPreferences?.getString("token"),
        page: currentPage,
      );

      StatuesRequest loadMoreStatus = handlingData(response);

      if (loadMoreStatus == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;

        List<ProductModel> newItems = (responseBody['data'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();

        favItems.addAll(newItems);

        // Check if there's more data
        if (newItems.isEmpty || newItems.length < 20) {
          hasMoreData = false;
        }
      } else if (loadMoreStatus == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
        currentPage--; // Rollback page number
      } else {
        currentPage--; // Rollback page number
      }
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> addItemToFav(dynamic itemId) async {
    var response = await favouriteRemoteData.addToFav(
        id: itemId, token: sharedPreferences?.getString("token"));
    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      // Kept
    } else {
      // Rollback on any failure
      favProductsId.remove(itemId);
      update(['fav_$itemId']);

      if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else if (statuesRequest == StatuesRequest.unauthorizedException) {
        messageErrorWithButton("Error", "You need to login ", () {
          Get.offAll(() => const LoginPage());
        }, "LogIn");
      } else {
        messageError("Error", "There is a problem. Please, try again later");
      }
    }
  }

  Future<void> removeItemFromFav(dynamic itemId) async {
    var response = await favouriteRemoteData.removeFromFav(
        id: itemId, token: sharedPreferences?.getString("token"));
    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      // Kept
    } else {
      // Rollback on any failure
      favProductsId.add(itemId);
      update(['fav_$itemId']);

      if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else if (statuesRequest == StatuesRequest.unauthorizedException) {
        messageErrorWithButton("Error", "You need to login ", () {
          Get.offAll(() => const LoginPage());
        }, "LogIn");
      } else {
        messageError("Error", "There is a problem. Please, try again later");
      }
    }
  }

  // Refresh functionality
  Future<void> refreshFavItems() async {
    resetPagination();
    favItemsFuture = getFavItems();
    await favItemsFuture;
    update();
  }
}
