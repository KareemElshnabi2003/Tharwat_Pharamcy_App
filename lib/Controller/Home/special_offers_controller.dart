import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
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
  HomeRemoteData homeRemoteData = HomeRemoteData(Get.find<Api>());

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
  bool isLoadingSearch = false;

  Timer? _debounce;

  void selectOffer(String id) {
    if (offerId == id && offerProducts.isNotEmpty) return;
    offerId = id;
    index = 1;
    more = true;
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
    await getOffers();
  }

  Future<void> refreshProductsPage() async {
    if (isSearch) {
      indexSearch = 1;
      await search();
    } else {
      index = 1;
      await getOfferProducts();
    }
    update();
  }

  void checkSearchOffer(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        isSearch = true;
        indexSearch = 1;
        moreSearch = false;
        searchList.clear();
        search();
      } else {
        isSearch = false;
        moreSearch = false;
        searchList.clear();
        favouriteController.syncProductsFavorite(offerProducts);
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
      var response = await homeRemoteData.searchSpecial(
          query: query,
          page: requestPage,
          token: sharedPreferences?.getString("token"));

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
          final lastPage = int.tryParse(
                  data['pagination']?['last_page']?.toString() ?? '') ??
              1;
          if (requestPage <= lastPage) {
            indexSearch = requestPage; // Only advance on success!
            moreSearch = indexSearch < lastPage;
            final newProducts =
                resList.map((item) => ProductModel.fromJson(item)).toList();
            if (!isLoadMore) {
              searchList = newProducts;
            } else {
              searchList.addAll(newProducts);
            }
            favouriteController.syncProductsFavorite(newProducts);
          } else {
            moreSearch = false;
          }
        },
      );
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

  Future<void> getOffers({bool isLoadMore = false}) async {
    final int requestPage = isLoadMore ? offersIndex + 1 : 1;

    if (!isLoadMore) {
      statuesRequest = StatuesRequest.loading;
      update();
    }

    try {
      var response = await homeRemoteData.getOffersData(
          page: requestPage, token: sharedPreferences?.getString("token"));

      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          List resList = data['data'] ?? [];
          final lastPage = int.tryParse(
                  data['pagination']?['last_page']?.toString() ?? '') ??
              1;
          if (requestPage <= lastPage) {
            offersIndex = requestPage; // Only advance on success!
            moreOffers = offersIndex < lastPage;
            final newOffers =
                resList.map((item) => OffersModel.fromJson(item)).toList();
            if (!isLoadMore) {
              offers = newOffers;
            } else {
              offers.addAll(newOffers);
            }
          } else {
            moreOffers = false;
          }
        },
      );
    } catch (e) {
      if (!isLoadMore) statuesRequest = handleException(e);
    } finally {
      update();
    }
  }

  Future<List<OfferProductsModel>> getOfferProducts(
      {bool isLoadMore = false}) async {
    final int requestPage = isLoadMore ? index + 1 : 1;

    if (!isLoadMore) {
      statuesRequest = StatuesRequest.loading;
      update();
    }

    try {
      var response = await homeRemoteData.getOfferProductsData(
          offerId: offerId,
          page: requestPage,
          token: sharedPreferences?.getString("token"));

      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          List resList = data['data'] ?? [];
          final lastPage = int.tryParse(
                  data['pagination']?['last_page']?.toString() ?? '') ??
              1;
          if (requestPage <= lastPage) {
            index = requestPage; // Only advance on success!
            more = index < lastPage;
            final newProducts = resList
                .map((item) => OfferProductsModel.fromJson(item))
                .toList();
            if (!isLoadMore) {
              offerProducts = newProducts;
            } else {
              offerProducts.addAll(newProducts);
            }
            for (final item in newProducts) {
              if (item.id != null) {
                favouriteController.syncProductFavorite(
                    item.id!, item.isFavourite == true);
              }
            }
          } else {
            more = false;
          }
        },
      );
    } catch (e) {
      if (!isLoadMore) statuesRequest = handleException(e);
    } finally {
      update();
    }
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
