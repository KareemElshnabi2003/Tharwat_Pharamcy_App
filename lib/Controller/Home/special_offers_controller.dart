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
  FavouriteController favouriteController = Get.put(FavouriteController());

  StatuesRequest statuesRequest = StatuesRequest.none;
  StatuesRequest loadMoreStatus = StatuesRequest.none;
  HomeRemoteData homeRemoteData = HomeRemoteData(Get.put(Api()));

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
    if (Get.arguments != null && Get.arguments is Map) {
      offerId = Get.arguments['id'] ?? "";
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
      index++;
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

  search({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      favouriteController.favProductsId.clear();
      statuesRequest = StatuesRequest.loading;
    }
    update();

    var response = await homeRemoteData.searchSpecial(
        query: searchController.text,
        page: indexSearch,
        token: sharedPreferences!.getString("token"));

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        List resList = data['data'];
        if (indexSearch <= data['pagination']['last_page']) {
          if (indexSearch == 1 && !isLoadMore) {
            searchList.clear();
            favouriteController.favProductsId.clear();
          }

          moreSearch = indexSearch < data['pagination']['last_page'];
          searchList.addAll(resList.map((item) => ProductModel.fromJson(item)));
          favouriteController.favProductsId.addAll(resList
              .where((item) => item['is_favourite'] == true)
              .map((e) => e['id']));

          indexSearch++;
        } else {
          moreSearch = false;
        }
      },
    );
    update();
  }

  getOffers({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      offers.clear();
      offersIndex = 1;
      statuesRequest = StatuesRequest.loading;
    }
    update();

    var response = await homeRemoteData.getOffersData(
        page: offersIndex, token: sharedPreferences!.getString("token"));

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        List resList = data['data'];
        if (offersIndex <= data['pagination']['last_page']) {
          moreOffers = offersIndex < data['pagination']['last_page'];
          offers.addAll(
              resList.map((item) => OffersModel.fromJson(item)).toList());
          offersIndex++;
        } else {
          moreOffers = false;
        }
      },
    );
    update();
  }

  Future<List<OfferProductsModel>> getOfferProducts(
      {bool isLoadMore = false}) async {
    if (!isLoadMore) {
      index = 1;
      offerProducts.clear();
      favouriteController.favProductsId.clear();
    }
    more = true;
    statuesRequest = StatuesRequest.loading;
    update();

    var response = await homeRemoteData.getOfferProductsData(
        offerId: offerId,
        page: index,
        token: sharedPreferences!.getString("token"));

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        List resList = data['data'];
        if (index <= data['pagination']['last_page']) {
          more = index < data['pagination']['last_page'];
          offerProducts
              .addAll(resList.map((item) => OfferProductsModel.fromJson(item)));
          favouriteController.favProductsId.addAll(resList
              .where((item) => item['is_favourite'] == true)
              .map((e) => e['id']));
        } else {
          more = false;
        }
      },
    );
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
