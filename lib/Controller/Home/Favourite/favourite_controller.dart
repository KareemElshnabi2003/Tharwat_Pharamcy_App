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
  FavouriteRemoteData favouriteRemoteData = FavouriteRemoteData(
      Get.isRegistered<Api>() ? Get.find<Api>() : Get.put(Api()));

  List<ProductModel> favItems = [];
  final Set<int> favProductsId = <int>{};
  final Set<int> _processingFavoriteIds = <int>{};

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

  Future<void> favProducts(dynamic rawId) async {
    final int? id =
        rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
    if (id == null) return;
    if (_processingFavoriteIds.contains(id)) return;
    _processingFavoriteIds.add(id);

    // Optimistic update
    favProductsId.add(id);
    update(['fav_$id']);

    try {
      await addItemToFav(id);
    } finally {
      _processingFavoriteIds.remove(id);
    }
  }

  Future<void> notFavProducts(dynamic rawId) async {
    final int? id =
        rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
    if (id == null) return;
    if (_processingFavoriteIds.contains(id)) return;
    _processingFavoriteIds.add(id);

    // Optimistic removal with rollback backup
    final originalIndex = favItems.indexWhere((item) => item.id == id);
    ProductModel? removedItem;
    if (originalIndex != -1) {
      removedItem = favItems.removeAt(originalIndex);
    }
    favProductsId.remove(id);
    update(['fav_$id']);
    // If on favorite screen, also update the list
    update();

    try {
      await removeItemFromFav(id,
          removedItem: removedItem, originalIndex: originalIndex);
    } finally {
      _processingFavoriteIds.remove(id);
    }
  }

  void change_1() {
    choose_1 = true;
    choose_2 = false;
    update();
  }

  void change_2() {
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

      if (statuesRequest == StatuesRequest.success &&
          response is Map<String, dynamic>) {
        Map<String, dynamic> responseBody = response;

        List<ProductModel> newItems = ((responseBody['data'] ?? []) as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();

        if (currentPage == 1) {
          favItems = newItems;
        } else {
          favItems.addAll(newItems);
        }

        for (final item in favItems) {
          if (item.id != null) {
            favProductsId.add(item.id!);
          }
        }

        // Pagination metadata
        final pagination = responseBody['pagination'];
        if (pagination is Map &&
            pagination['last_page'] != null &&
            pagination['current_page'] != null) {
          final int lastPage = pagination['last_page'] as int;
          final int curr = pagination['current_page'] as int;
          hasMoreData = curr < lastPage;
        } else {
          hasMoreData = newItems.isNotEmpty;
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

  // Load more for pagination - Retry-safe
  Future<void> loadMoreFavItems() async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    update();

    try {
      final nextPage = currentPage + 1;

      var response = await favouriteRemoteData.getFavProducts(
        token: sharedPreferences?.getString("token"),
        page: nextPage,
      );

      StatuesRequest loadMoreStatus = handlingData(response);

      if (loadMoreStatus == StatuesRequest.success &&
          response is Map<String, dynamic>) {
        currentPage = nextPage;
        Map<String, dynamic> responseBody = response;

        List<ProductModel> newItems = ((responseBody['data'] ?? []) as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();

        favItems.addAll(newItems);
        for (final item in newItems) {
          if (item.id != null) {
            favProductsId.add(item.id!);
          }
        }

        final pagination = responseBody['pagination'];
        if (pagination is Map &&
            pagination['last_page'] != null &&
            pagination['current_page'] != null) {
          final int lastPage = pagination['last_page'] as int;
          final int curr = pagination['current_page'] as int;
          hasMoreData = curr < lastPage;
        } else {
          hasMoreData = newItems.isNotEmpty;
        }
      } else if (loadMoreStatus == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please, try again later");
      }
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> addItemToFav(int itemId) async {
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

  Future<void> removeItemFromFav(dynamic rawId,
      {ProductModel? removedItem, int? originalIndex}) async {
    final int? itemId =
        rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
    if (itemId == null) return;
    var response = await favouriteRemoteData.removeFromFav(
        id: itemId, token: sharedPreferences?.getString("token"));
    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      // Kept
    } else {
      // Rollback on failure: restore both ID and ProductModel
      favProductsId.add(itemId);
      if (removedItem != null) {
        if (originalIndex != null &&
            originalIndex >= 0 &&
            originalIndex <= favItems.length) {
          favItems.insert(originalIndex, removedItem);
        } else {
          favItems.add(removedItem);
        }
        update();
      }
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
