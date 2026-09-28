import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/home_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/Data/Model/Home/offer_products_model.dart';
import 'package:tharwat_pharmacy/Data/Model/Home/offers_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class SpecialOffersController extends GetxController {
  FavouriteController favouriteController =
      Get.isRegistered<FavouriteController>()
          ? Get.find<FavouriteController>()
          : Get.put(FavouriteController());

  StatuesRequest statuesRequest = StatuesRequest.none;
  StatuesRequest loadMoreStatus = StatuesRequest.none;
  HomeRemoteData homeRemoteData = HomeRemoteData(
      Get.isRegistered<Api>() ? Get.find<Api>() : Get.put(Api()));

  List<OffersModel> offers = [];
  List<OfferProductsModel> offerProducts = [];
  List<ProductModel> searchList = [];
  bool isSearch = false;

  ScrollController offersScrollController = ScrollController();
  ScrollController productsScrollController = ScrollController();

  TextEditingController searchController = TextEditingController();
  String offerId = '';

  bool more = false;
  bool moreOffers = false;
  int index = 1;
  int offersIndex = 1;
  bool moreSearch = false;
  int indexSearch = 1;
  int _searchRequestId = 0;

  bool isLoadingMore = false;
  bool isLoadingMoreOffers = false;
  bool isLoadingMoreSearch = false;

  Timer? _debounce;

  void selectOffer(String id) {
    if (offerId == id && offerProducts.isNotEmpty) return;
    offerId = id;
    index = 1;
    more = true;
    offerProducts.clear();
    favouriteController.favProductsId.clear();
    getOfferProducts();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      offerId = args['id']?.toString() ?? "";
    }
    if (offerId.isNotEmpty) {
      getOfferProducts();
    } else {
      getOffers();
    }
    offersScrollController.addListener(_offersScrollListener);
    productsScrollController.addListener(_productsScrollListener);
  }

  void _offersScrollListener() {
    if (offersScrollController.position.pixels >=
        offersScrollController.position.maxScrollExtent - 200) {
      if (moreOffers && !isLoadingMoreOffers) getMoreOffers();
    }
  }

  void _productsScrollListener() {
    if (productsScrollController.position.pixels >=
        productsScrollController.position.maxScrollExtent - 200) {
      if (isSearch) {
        if (moreSearch && !isLoadingMoreSearch) getMoreSearch();
      } else {
        if (more && !isLoadingMore) getMoreProducts();
      }
    }
  }

  Future<void> getMoreOffers() async {
    if (!moreOffers || isLoadingMoreOffers) return;
    isLoadingMoreOffers = true;
    loadMoreStatus = StatuesRequest.loading;
    update();
    try {
      await getOffers(isLoadMore: true);
    } finally {
      isLoadingMoreOffers = false;
      loadMoreStatus = StatuesRequest.none;
      update();
    }
  }

  Future<void> getMoreProducts() async {
    if (!more || isLoadingMore) return;
    isLoadingMore = true;
    loadMoreStatus = StatuesRequest.loading;
    update();
    try {
      await getOfferProducts(isLoadMore: true);
    } finally {
      isLoadingMore = false;
      loadMoreStatus = StatuesRequest.none;
      update();
    }
  }

  Future<void> getMoreSearch() async {
    if (!moreSearch || isLoadingMoreSearch) return;
    isLoadingMoreSearch = true;
    loadMoreStatus = StatuesRequest.loading;
    update();
    try {
      await search(isLoadMore: true);
    } finally {
      isLoadingMoreSearch = false;
      loadMoreStatus = StatuesRequest.none;
      update();
    }
  }

  Future<void> refreshOffersPage() async {
    offersIndex = 1;
    moreOffers = true;
    isLoadingMoreOffers = false;
    offers.clear();
    await getOffers();
  }

  Future<void> refreshProductsPage() async {
    if (isSearch) {
      indexSearch = 1;
      searchList.clear();
      await search();
    } else {
      index = 1;
      offerProducts.clear();
      await getOfferProducts();
    }
    update();
  }

  void checkSearchOffer(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (value.trim().isNotEmpty) {
        isSearch = true;
        indexSearch = 1;
        moreSearch = false;
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
    final currentRequestId = ++_searchRequestId;
    final int requestPage = isLoadMore ? indexSearch + 1 : 1;

    if (!isLoadMore) {
      searchList.clear();
      favouriteController.favProductsId.clear();
      statuesRequest = StatuesRequest.loading;
      update();
    }

    var response = await homeRemoteData.searchSpecial(
        query: searchController.text,
        page: requestPage,
        token: sharedPreferences!.getString("token"));

    // Drop stale response
    if (currentRequestId != _searchRequestId) {
      return;
    }

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        if (currentRequestId != _searchRequestId) return;
        List resList = data['data'] ?? [];
        final lastPage = data['pagination']?['last_page'] ?? 1;
        if (requestPage <= lastPage) {
          indexSearch = requestPage; // Only advance on success!
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
        } else {
          moreSearch = false;
        }
      },
    );
    update();
  }

  Future<void> getOffers({bool isLoadMore = false}) async {
    final int requestPage = isLoadMore ? offersIndex + 1 : 1;

    if (!isLoadMore) {
      offers.clear();
      statuesRequest = StatuesRequest.loading;
      update();
    }

    var response = await homeRemoteData.getOffersData(
        page: requestPage, token: sharedPreferences!.getString("token"));

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        List resList = data['data'] ?? [];
        final lastPage = data['pagination']?['last_page'] ?? 1;
        if (requestPage <= lastPage) {
          offersIndex = requestPage; // Only advance on success!
          moreOffers = offersIndex < lastPage;
          offers.addAll(
              resList.map((item) => OffersModel.fromJson(item)).toList());
        } else {
          moreOffers = false;
        }
      },
    );
    update();
  }

  Future<List<OfferProductsModel>> getOfferProducts(
      {bool isLoadMore = false}) async {
    final int requestPage = isLoadMore ? index + 1 : 1;

    if (!isLoadMore) {
      offerProducts.clear();
      favouriteController.favProductsId.clear();
      statuesRequest = StatuesRequest.loading;
      update();
    }

    var response = await homeRemoteData.getOfferProductsData(
        offerId: offerId,
        page: requestPage,
        token: sharedPreferences!.getString("token"));

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        List resList = data['data'] ?? [];
        final lastPage = data['pagination']?['last_page'] ?? 1;
        if (requestPage <= lastPage) {
          index = requestPage; // Only advance on success!
          more = index < lastPage;
          offerProducts
              .addAll(resList.map((item) => OfferProductsModel.fromJson(item)));
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
        } else {
          more = false;
        }
      },
    );
    update();
    return offerProducts;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    offersScrollController.dispose();
    productsScrollController.dispose();
    super.onClose();
  }
}
