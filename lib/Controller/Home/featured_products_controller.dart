import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/home_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class FeaturedProductsController extends GetxController {
  FavouriteController favouriteController =
      Get.isRegistered<FavouriteController>()
          ? Get.find<FavouriteController>()
          : Get.put(FavouriteController());

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  StatuesRequest statuesRequest = StatuesRequest.none;
  HomeRemoteData homeRemoteData = HomeRemoteData(
      Get.isRegistered<Api>() ? Get.find<Api>() : Get.put(Api()));

  List<ProductModel> trendProducts = [];
  List<ProductModel> searchList = [];

  bool isSearch = false;
  bool more = false;
  int index = 1;
  bool moreSearch = false;
  int indexSearch = 1;
  int _searchRequestId = 0;
  Timer? _debounce;

  // Loading states for infinite scroll
  bool isLoadingMore = false;
  bool isLoadingMoreSearch = false;

  /// Setup scroll listener for infinite scroll
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        // Load more when user is 200px from bottom
        if (isSearch) {
          loadMoreSearchResults();
        } else {
          loadMoreProducts();
        }
      }
    });
  }

  /// Refresh products page
  Future<void> refreshProducts() async {
    if (isSearch) {
      // Refresh search results
      indexSearch = 1;
      searchList.clear();
      favouriteController.favProductsId.clear();
      await search();
    } else {
      // Refresh products
      index = 1;
      trendProducts.clear();
      favouriteController.favProductsId.clear();
      await getTrendingProducts();
    }
  }

  /// Load more search results
  Future<void> loadMoreSearchResults() async {
    if (!moreSearch || isLoadingMoreSearch) return;

    isLoadingMoreSearch = true;
    update();

    try {
      await search(isLoadMore: true);
    } finally {
      isLoadingMoreSearch = false;
      update();
    }
  }

  /// Load more products
  Future<void> loadMoreProducts() async {
    if (!more || isLoadingMore) return;

    isLoadingMore = true;
    update();

    try {
      await getTrendingProducts(isLoadMore: true);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  void checkSearchFeature(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        isSearch = true;
        more = false;
        indexSearch = 1;
        search(isLoadMore: false);
      } else {
        isSearch = false;
        indexSearch = 1;
        index = 1;
        moreSearch = false;
        searchList.clear();
        favouriteController.favProductsId.clear();
        getTrendingProducts(isLoadMore: false);
      }
    });
  }

  Future<void> getTrendingProducts({bool isLoadMore = false}) async {
    final int requestPage = isLoadMore ? index + 1 : 1;

    if (!isLoadMore) {
      favouriteController.favProductsId.clear();
      trendProducts.clear();
      statuesRequest = StatuesRequest.loading;
      update();
    }

    var response = await homeRemoteData.getTrendProduct(
        page: requestPage.toString(),
        token: sharedPreferences?.getString("token"));

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      index = requestPage; // Only advance on success!
      Map<String, dynamic> responseBody = response;
      List resList = responseBody['data'] ?? [];

      int lastPage = responseBody['pagination']?['last_page'] ?? 1;
      more = index < lastPage;

      trendProducts.addAll(resList.map((item) => ProductModel.fromJson(item)));
      for (final item in resList) {
        if (item['is_favourite'] == true && item['id'] != null) {
          final id = item['id'] is int
              ? item['id'] as int
              : int.tryParse(item['id'].toString());
          if (id != null) {
            favouriteController.favProductsId.add(id);
          }
        }
      }
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please, try again later");
    }
    update();
  }

  Future<void> search({bool isLoadMore = false}) async {
    final currentRequestId = ++_searchRequestId;
    final int requestPage = isLoadMore ? indexSearch + 1 : 1;

    if (!isLoadMore) {
      searchList.clear();
      favouriteController.favProductsId.clear();
      statuesRequest = StatuesRequest.loading;
      update();
    }

    var response = await homeRemoteData.searchFeatures(
        query: searchController.text,
        page: requestPage,
        token: sharedPreferences?.getString("token"));

    // Drop stale response
    if (currentRequestId != _searchRequestId) {
      return;
    }

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      indexSearch = requestPage; // Only advance on success!
      Map<String, dynamic> responseBody = response;
      List resList = responseBody['data'] ?? [];
      int lastPage = responseBody['pagination']?['last_page'] ?? 1;

      moreSearch = indexSearch < lastPage;

      searchList.addAll(resList.map((item) => ProductModel.fromJson(item)));
      for (final item in resList) {
        if (item['is_favourite'] == true && item['id'] != null) {
          final id = item['id'] is int
              ? item['id'] as int
              : int.tryParse(item['id'].toString());
          if (id != null) {
            favouriteController.favProductsId.add(id);
          }
        }
      }
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please, try again later");
    }
    update();
  }

  @override
  void onInit() {
    _setupScrollListener();
    getTrendingProducts(); // Load initial data
    super.onInit();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
