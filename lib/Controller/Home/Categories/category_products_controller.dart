import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Categories/categories_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class CategoryProductsController extends GetxController {
  FavouriteController favouriteController = Get.put(FavouriteController());

  StatuesRequest statuesRequest = StatuesRequest.none;
  List<ProductModel> products = [];
  CategoriesRemoteData categoriesRemoteData =
      CategoriesRemoteData(Get.put(Api()));
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String categoryTitle = '';
  List<ProductModel> searchList = [];

  String catId = "";
  bool isSearch = false;
  bool more = false;
  int index = 1;
  bool moreSearch = false;
  int indexSearch = 1;
  Timer? _debounce;

  // Loading states for infinite scroll
  bool isLoadingMore = false;
  bool isLoadingMoreSearch = false;

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
      products.clear();
      favouriteController.favProductsId.clear();
      await getProducts();
    }
    update();
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
      index++;
      await getProducts(isLoadMore: true);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  /// Setup scroll listener for infinite scroll
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (isSearch) {
          loadMoreSearchResults();
        } else {
          loadMoreProducts();
        }
      }
    });
  }

  void checkSearchCAT(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (value.trim().isNotEmpty) {
        isSearch = true;
        indexSearch = 1;
        more = false;
        searchList.clear();
        search();
      } else {
        isSearch = false;
        moreSearch = false;
        searchList.clear();
        favouriteController.favProductsId.clear();
        update();
      }
    });
  }

  Future<void> search({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      if (indexSearch == 1) {
        favouriteController.favProductsId.clear();
      }
      statuesRequest = StatuesRequest.loading;
      update();
    }

    var response = await categoriesRemoteData.search(
        catId: catId,
        query: searchController.text,
        page: indexSearch,
        token: sharedPreferences!.getString("token"));

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      final responseBody = response;
      List resList = responseBody['data'];

      if (indexSearch <= responseBody['pagination']['last_page']) {
        if (indexSearch == 1) {
          searchList.clear();
          favouriteController.favProductsId.clear();
        }

        moreSearch = indexSearch < responseBody['pagination']['last_page'];
        indexSearch++;

        searchList.addAll(resList.map((item) => ProductModel.fromJson(item)));
        favouriteController.favProductsId.addAll(resList
            .where((item) => item['is_favourite'] == true)
            .map((e) => e['id']));
      } else {
        moreSearch = false;
      }
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please, try again later");
    }
    update();
  }

  Future<void> getProducts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      if (index == 1) {
        favouriteController.favProductsId.clear();
        products.clear();
      }
      statuesRequest = StatuesRequest.loading;
      update();
    }

    var response = await categoriesRemoteData.getProductsCategories(
        page: index,
        catId: catId,
        token: sharedPreferences!.getString("token"));

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      final responseBody = response;
      List resList = responseBody['data'];

      int lastPage = responseBody['pagination']['last_page'];

      more = index < lastPage;

      products.addAll(resList.map((item) => ProductModel.fromJson(item)));
      favouriteController.favProductsId.addAll(resList
          .where((item) => item['is_favourite'] == true)
          .map((e) => e['id']));
    } else if (statuesRequest == StatuesRequest.socketException) {
      if (index > 1) index--; // Rollback page increment on error
      messageError("Error", "please, check your internet");
    } else {
      if (index > 1) index--; // Rollback page increment on error
      messageError("Error", "There is a problem. Please, try again later");
    }
    update();
  }

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is Map) {
      catId = Get.arguments['id']?.toString() ?? "";
      categoryTitle = Get.arguments['name']?.toString() ?? "";
    }

    _setupScrollListener();
    getProducts();
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
