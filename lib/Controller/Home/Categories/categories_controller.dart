import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Categories/categories_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/category_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class CategoriesController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  CategoriesRemoteData categoriesRemoteData =
      CategoriesRemoteData(Get.find<Api>());

  List<CategoryModel> categories = [];
  List<CategoryModel> subCategories = [];
  ScrollController scrollController = ScrollController();

  int indexCat = 1;
  int currentPage = 1;
  bool hasMoreSubCategories = true;
  bool isLoadingMore = false;
  int _categoryRequestId = 0;

  bool choose_1 = true;
  bool choose_2 = false;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    getCategories();
  }

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
    statuesRequest = StatuesRequest.loading;
    update();

    try {
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
    } catch (e) {
      statuesRequest = handleException(e);
    } finally {
      update();
    }
  }

  Future<void> getSubCategories({int? page}) async {
    final currentRequestId = ++_categoryRequestId;
    final int requestPage = page ?? currentPage;
    if (requestPage == 1) {
      statuesRequest = StatuesRequest.loading;
      update();
    }

    try {
      var response = await categoriesRemoteData.getSubCategories(
          catId: indexCat,
          page: requestPage,
          token: sharedPreferences?.getString("token"));

      if (currentRequestId != _categoryRequestId) return;

      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          if (currentRequestId != _categoryRequestId) return;
          currentPage = requestPage; // Advance only on success!
          List<CategoryModel> newSubCategories = ((data['data'] ?? []) as List)
              .map((item) => CategoryModel.fromJson(item))
              .toList();

          if (requestPage == 1) {
            subCategories = newSubCategories;
          } else {
            subCategories.addAll(newSubCategories);
          }

          if (data.containsKey('pagination') && data['pagination'] is Map) {
            int currentPageNum = int.tryParse(
                    data['pagination']['current_page']?.toString() ?? '') ??
                1;
            int lastPage = int.tryParse(
                    data['pagination']['last_page']?.toString() ?? '') ??
                1;
            hasMoreSubCategories = currentPageNum < lastPage;
          } else {
            hasMoreSubCategories = newSubCategories.isNotEmpty;
          }
        },
      );
    } catch (e) {
      if (currentRequestId == _categoryRequestId) {
        statuesRequest = handleException(e);
      }
    } finally {
      if (currentRequestId == _categoryRequestId) {
        update();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
