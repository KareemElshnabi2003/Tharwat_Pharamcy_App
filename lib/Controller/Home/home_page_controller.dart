import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/home_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/Data/Model/Home/home_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class HomePageController extends GetxController {
  FavouriteController favouriteController =
      Get.isRegistered<FavouriteController>()
          ? Get.find<FavouriteController>()
          : Get.put(FavouriteController());
  TextEditingController searchController = TextEditingController();

  ScrollController scrollController = ScrollController();
  StatuesRequest statuesRequest = StatuesRequest.none;
  StatuesRequest loadMoreStatus = StatuesRequest.none;

  HomeRemoteData homeRemoteData = HomeRemoteData(
      Get.isRegistered<Api>() ? Get.find<Api>() : Get.put(Api()));
  HomeModel? homeModel;
  List<ProductModel> searchList = [];
  bool isSearch = false;
  bool more = false;
  bool isLoadingMore = false;
  bool isLoadingHome = false;
  bool isLoadingSearch = false;
  int _searchRequestId = 0;
  int index = 1;
  Timer? _debounce;
  Future<HomeModel?>? homeDataFuture;

  @override
  void onInit() {
    super.onInit();
    homeDataFuture = getHomeData();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (isSearch && more && !isLoadingMore) {
        getMore();
      }
    }
  }

  Future<void> refreshPage() async {
    if (isSearch) {
      index = 1;
      await search();
    } else {
      homeDataFuture = getHomeData();
      await homeDataFuture;
      update();
    }
  }

  void checkSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isNotEmpty) {
        isSearch = true;
        index = 1;
        more = true;
        await search();
      } else {
        isSearch = false;
        searchList.clear();
        favouriteController.favProductsId.clear();
        index = 1;
        more = false;
        update();
      }
    });
  }

  Future<HomeModel?> getHomeData() async {
    if (isLoadingHome) return homeModel;
    isLoadingHome = true;
    try {
      favouriteController.favProductsId.clear();
      statuesRequest = StatuesRequest.loading;
      update();

      var response = await homeRemoteData.getHomeData(
          token: sharedPreferences?.getString("token"));
      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          homeModel = HomeModel.fromJson(data);

          if (data['data']?['trending_products']?['data'] != null) {
            for (final item
                in (data['data']['trending_products']['data'] as List)) {
              if (item['is_favourite'] == true && item['id'] != null) {
                final id = item['id'] is int
                    ? item['id'] as int
                    : int.tryParse(item['id'].toString());
                if (id != null) {
                  favouriteController.favProductsId.add(id);
                }
              }
            }
          }

          if (data['data']?['most_ordered_products']?['data'] != null) {
            for (final item
                in (data['data']['most_ordered_products']['data'] as List)) {
              if (item['is_favourite'] == true && item['id'] != null) {
                final id = item['id'] is int
                    ? item['id'] as int
                    : int.tryParse(item['id'].toString());
                if (id != null) {
                  favouriteController.favProductsId.add(id);
                }
              }
            }
          }
        },
      );
      return homeModel;
    } catch (e) {
      statuesRequest = StatuesRequest.serverError;
      return null;
    } finally {
      isLoadingHome = false;
      update();
    }
  }

  Future<void> getMore() async {
    if (more && !isLoadingMore) {
      isLoadingMore = true;
      loadMoreStatus = StatuesRequest.loading;
      update();

      try {
        await search(isLoadMore: true);
      } finally {
        isLoadingMore = false;
        loadMoreStatus = StatuesRequest.none;
        update();
      }
    }
  }

  Future<void> search({String? query, bool isLoadMore = false}) async {
    final currentRequestId = ++_searchRequestId;
    final int requestPage = isLoadMore ? index : 1;
    final String searchQuery = query ?? searchController.text;

    if (!isLoadMore) {
      isLoadingSearch = true;
      searchList.clear();
      favouriteController.favProductsId.clear();
    }
    update();

    try {
      var response = await homeRemoteData.searchHome(
          query: searchQuery,
          page: requestPage,
          token: sharedPreferences?.getString("token"));

      // Drop stale response
      if (currentRequestId != _searchRequestId) {
        return;
      }

      final status = handlingData(response);
      if (!isLoadMore) {
        statuesRequest = status;
      }

      handleApiResponse(
        status: status,
        response: response,
        onSuccess: (data) {
          if (currentRequestId != _searchRequestId) return;
          List resList = data['data'] ?? [];
          int lastPage = data['pagination']?['last_page'] ?? 1;
          if (requestPage <= lastPage) {
            if (!isLoadMore) {
              searchList.clear();
              index = 1;
            }

            more = requestPage < lastPage;
            searchList
                .addAll(resList.map((item) => ProductModel.fromJson(item)));

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

            // Only advance upon success!
            index = requestPage + 1;
          } else {
            more = false;
          }
        },
      );
    } finally {
      if (currentRequestId == _searchRequestId) {
        if (!isLoadMore) {
          isLoadingSearch = false;
        }
        update();
      }
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
