import 'dart:async';
import 'dart:developer';

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
    await getProducts();

    isLoadingMore = false;
    update();
  }

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

  getMore() async {
    if (moreSearch == true) {
      await search();
      update();
    }
  }

  bool click = false;
  onClickSeeMore() {
    click = true;
    index++;
    update();
  }

  checkSearchCAT(value) async {
    index = 1;
    indexSearch = 1;
    click = false;

    products.clear();

    searchController.text = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        isSearch = true;
        more = false;
        search();
      } else {
        isSearch = false;
        moreSearch = false;
        searchList.clear();
        favouriteController.favProductsId.clear();
        getProducts();
        update();
      }
    });
  }

  search() async {
    // Don't clear favorites if loading more
    if (indexSearch == 1) {
      favouriteController.favProductsId.clear();
    }

    statuesRequest = StatuesRequest.loading;
    update();

    var response = await categoriesRemoteData.search(
        catId: catId,
        query: searchController.text,
        page: indexSearch,
        token: sharedPreferences!.getString("token"));

    print(" response ??? $response");

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      final responseBody = response;
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
      } else {
        print(
            "current :: ${responseBody['pagination']['current_page'].toString()}");
        moreSearch = false;
      }
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please, try again later");
    }
    update();
  }

  Future<void> getProducts() async {
    // Don't clear favorites if loading more
    if (index == 1) {
      favouriteController.favProductsId.clear();
      products.clear();
    }

    statuesRequest = StatuesRequest.loading;
    update();

    log("index >>>> $index");
    var response = await categoriesRemoteData.getProductsCategories(
        page: index,
        catId: catId,
        token: sharedPreferences!.getString("token"));
    print(" response ??? $response");

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      final responseBody = response;
      List resList = responseBody['data'];
      print("response :: $responseBody");

      int lastPage = responseBody['pagination']['last_page'];

      more = index < lastPage;

      print(
          "current :: ${responseBody['pagination']['current_page'].toString()}");

      products.addAll(resList.map((item) => ProductModel.fromJson(item)));
      favouriteController.favProductsId.addAll(resList
          .where((item) => item['is_favourite'] == true)
          .map((e) => e['id']));
      print("items :: ${products.length}");
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
    catId = Get.arguments['id'] ?? "";
    categoryTitle = Get.arguments['name'] ?? "";

    // Setup scroll listener
    _setupScrollListener();

    // Load initial products
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
