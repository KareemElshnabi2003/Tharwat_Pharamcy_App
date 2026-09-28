import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Categories/categories_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/category_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class CategoriesController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  CategoriesRemoteData categoriesRemoteData = CategoriesRemoteData(
      Get.isRegistered<Api>() ? Get.find<Api>() : Get.put(Api()));

  List<CategoryModel> categories = [];
  List<CategoryModel> subCategories = [];
  ScrollController scrollController = ScrollController();

  int indexCat = 1;
  int currentPage = 1;
  bool hasMoreSubCategories = true;
  bool isLoadingMore = false;

  bool choose_1 = true;
  bool choose_2 = false;

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreSubCategories();
      }
    });
  }

  Future<void> refreshSubCategories() async {
    currentPage = 1;
    subCategories.clear();
    hasMoreSubCategories = true;
    await getSubCategories();
  }

  Future<void> loadMoreSubCategories() async {
    if (!hasMoreSubCategories || isLoadingMore) return;
    isLoadingMore = true;
    update();
    try {
      final nextPage = currentPage + 1;
      await getSubCategories(page: nextPage);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  void changeIndex(int? index) {
    if (index == null) return;
    indexCat = index;
    currentPage = 1;
    subCategories.clear();
    hasMoreSubCategories = true;
    getSubCategories();
    update();
  }

  void change_1(int index) {
    indexCat = index;
    choose_1 = true;
    choose_2 = false;
    update();
  }

  void change_2(int index) {
    indexCat = index;
    choose_1 = false;
    choose_2 = true;
    update();
  }

  Future<void> getCategories() async {
    categories.clear();
    statuesRequest = StatuesRequest.loading;
    update();

    var response = await categoriesRemoteData.getCategories(
        token: sharedPreferences?.getString("token"));
    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        categories = ((data['data'] ?? []) as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList();
        if (categories.isNotEmpty) {
          indexCat = categories[0].id!;
          getSubCategories();
        }
      },
    );
    update();
  }

  Future<void> getSubCategories({int? page}) async {
    final int requestPage = page ?? currentPage;
    if (requestPage == 1) subCategories.clear();
    statuesRequest = StatuesRequest.loading;
    update();

    var response = await categoriesRemoteData.getSubCategories(
        catId: indexCat,
        page: requestPage,
        token: sharedPreferences?.getString("token"));

    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        currentPage = requestPage; // Advance only on success!
        List<CategoryModel> newSubCategories = ((data['data'] ?? []) as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList();

        subCategories.addAll(newSubCategories);

        if (data.containsKey('pagination') && data['pagination'] is Map) {
          int currentPageNum = data['pagination']['current_page'] ?? 1;
          int lastPage = data['pagination']['last_page'] ?? 1;
          hasMoreSubCategories = currentPageNum < lastPage;
        } else {
          hasMoreSubCategories = newSubCategories.isNotEmpty;
        }
      },
    );
    update();
  }

  @override
  void onInit() {
    _setupScrollListener();
    getCategories();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
