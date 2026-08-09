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
  FavouriteController favouriteController = Get.put(FavouriteController());

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  StatuesRequest statuesRequest = StatuesRequest.none;
  HomeRemoteData homeRemoteData = HomeRemoteData(Get.put(Api()));

  List<ProductModel> trendProducts = [];
  List<ProductModel> searchList = [];

  bool isSearch = false;
  bool more = false;
  int index = 1;
  bool moreSearch = false;
  int indexSearch = 1;
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

    await search();

    isLoadingMoreSearch = false;
    update();
  }

  /// Load more products
  Future<void> loadMoreProducts() async {
    if (!more || isLoadingMore) return;

    isLoadingMore = true;
    update();

    index++;
    await getTrendingProducts();

    isLoadingMore = false;
    update();
  }

  getMore() {
    if (moreSearch == true) {
      search();
      update();
    }
  }

  bool click = false;
  onClickSeeMore() {
    click = true;
    index++;
    update();
  }

  checkSearchFeature(value) {
    indexSearch = 1;
    trendProducts.clear();
    index = 1;
    click = false;

    searchController.text = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        isSearch = true;
        more = false;

        search();
        update();
      } else {
        isSearch = false;

        indexSearch = 1;
        index = 1;
        moreSearch = false;

        searchList.clear();
        favouriteController.favProductsId.clear();
        getTrendingProducts();
        update();
      }
    });
  }

  Future<void> getTrendingProducts() async {
    // Don't clear favorites if loading more
    if (index == 1) {
      favouriteController.favProductsId.clear();
      trendProducts.clear();
    }

    statuesRequest = StatuesRequest.loading;
    update();

    var response = await homeRemoteData.getTrendProduct(
        page: index.toString(), token: sharedPreferences!.getString("token"));
    print(" response ??? $response");

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      Map<String, dynamic> responseBody = response;
      List resList = responseBody['data'];
      print("response :: $responseBody");

      int lastPage = responseBody['pagination']['last_page'];
      more = index < lastPage;

      print(
          "current :: ${responseBody['pagination']['current_page'].toString()}");

      trendProducts.addAll(resList.map((item) => ProductModel.fromJson(item)));
      favouriteController.favProductsId.addAll(resList
          .where((item) => item['is_favourite'] == true)
          .map((e) => e['id']));
      print("items :: ${trendProducts.length}");
    } else if (statuesRequest == StatuesRequest.socketException) {
      if (index > 1) index--; // Rollback on error
      messageError("Error", "please, check your internet");
    } else {
      if (index > 1) index--; // Rollback on error
      messageError("Error", "There is a problem. Please, try again later");
    }
    update();
  }

  search() async {
    // Don't clear favorites if loading more
    if (indexSearch == 1) {
      favouriteController.favProductsId.clear();
    }

    statuesRequest = StatuesRequest.loading;
    update();

    var response = await homeRemoteData.searchFeatures(
        query: searchController.text,
        page: indexSearch,
        token: sharedPreferences!.getString("token"));

    print(" response ??? $response");

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      Map<String, dynamic> responseBody = response;
      List resList = responseBody['data'];
      print("response :: $responseBody");

      if (indexSearch <= responseBody['pagination']['last_page']) {
        if (indexSearch == 1) {
          searchList.clear();
          favouriteController.favProductsId.clear();
        }

        moreSearch = indexSearch < responseBody['pagination']['last_page'];
        indexSearch++;

        print(
            "current :: ${responseBody['pagination']['current_page'].toString()}");
        searchList.addAll(resList.map((item) => ProductModel.fromJson(item)));
        favouriteController.favProductsId.addAll(resList
            .where((item) => item['is_favourite'] == true)
            .map((e) => e['id']));
        print("items :: ${searchList.length}");
        print("items :: ${favouriteController.favProductsId.length}");
      } else {
        print(
            "current :: ${responseBody['pagination']['current_page'].toString()}");
        moreSearch = false;
      }
    } else if (statuesRequest == StatuesRequest.socketException) {
      if (indexSearch > 1) indexSearch--; // Rollback on error
      messageError("Error", "please, check your internet");
    } else {
      if (indexSearch > 1) indexSearch--; // Rollback on error
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
