import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Categories/categories_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class CategoryProductsController extends GetxController {
  FavouriteController favouriteController =
      Get.isRegistered<FavouriteController>()
          ? Get.find<FavouriteController>()
          : Get.put(FavouriteController());

  StatuesRequest statuesRequest = StatuesRequest.none;
  List<ProductModel> products = [];
  CategoriesRemoteData categoriesRemoteData =
      CategoriesRemoteData(Get.find<Api>());
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
  int _searchRequestId = 0;
  Timer? _debounce;

  // Loading states for infinite scroll & search
  bool isLoadingMore = false;
  bool isLoadingMoreSearch = false;
  bool isLoadingSearch = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      catId = args['id']?.toString() ?? "";
      categoryTitle = args['name']?.toString() ?? "";
    }

    _setupScrollListener();
    getProducts();
  }

  /// Refresh products page
  Future<void> refreshProducts() async {
    if (isSearch) {
      indexSearch = 1;
      await search();
    } else {
      index = 1;
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
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        isSearch = true;
        indexSearch = 1;
        more = false;
        searchList.clear();
        search();
      } else {
        isSearch = false;
        moreSearch = false;
        searchList.clear();
        favouriteController.syncProductsFavorite(products);
        update();
      }
    });
  }

  Future<void> search({bool isLoadMore = false}) async {
    final currentRequestId = ++_searchRequestId;
    final int requestPage = isLoadMore ? indexSearch + 1 : 1;
    final String query = searchController.text.trim();

    if (!isLoadMore) {
      isLoadingSearch = true;
      searchList.clear();
      statuesRequest = StatuesRequest.loading;
      update();
    }

    try {
      var response = await categoriesRemoteData.search(
          catId: catId,
          query: query,
          page: requestPage,
          token: sharedPreferences!.getString("token"));

      // Drop stale response
      if (currentRequestId != _searchRequestId) {
        return;
      }

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        indexSearch = requestPage; // Only advance on success!
        final responseBody = response;
        List resList = responseBody['data'] ?? [];
        final lastPage = int.tryParse(
                responseBody['pagination']?['last_page']?.toString() ?? '') ??
            1;

        moreSearch = indexSearch < lastPage;

        final newProducts =
            resList.map((item) => ProductModel.fromJson(item)).toList();
        if (!isLoadMore) {
          searchList = newProducts;
        } else {
          searchList.addAll(newProducts);
        }
        favouriteController.syncProductsFavorite(newProducts);
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please, try again later");
      }
    } catch (e) {
      if (!isLoadMore) statuesRequest = handleException(e);
    } finally {
      if (currentRequestId == _searchRequestId) {
        if (!isLoadMore) {
          isLoadingSearch = false;
        }
        update();
      }
    }
  }

  Future<void> getProducts({bool isLoadMore = false}) async {
    final int requestPage = isLoadMore ? index + 1 : 1;

    if (!isLoadMore) {
      statuesRequest = StatuesRequest.loading;
      update();
    }

    try {
      var response = await categoriesRemoteData.getProductsCategories(
          page: requestPage,
          catId: catId,
          token: sharedPreferences!.getString("token"));

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        index = requestPage; // Only advance on success!
        final responseBody = response;
        List resList = responseBody['data'] ?? [];
        int lastPage = int.tryParse(
                responseBody['pagination']?['last_page']?.toString() ?? '') ??
            1;

        more = index < lastPage;

        final newProducts =
            resList.map((item) => ProductModel.fromJson(item)).toList();
        if (!isLoadMore) {
          products = newProducts;
        } else {
          products.addAll(newProducts);
        }
        favouriteController.syncProductsFavorite(newProducts);
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please, try again later");
      }
    } catch (e) {
      if (!isLoadMore) statuesRequest = handleException(e);
    } finally {
      update();
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
