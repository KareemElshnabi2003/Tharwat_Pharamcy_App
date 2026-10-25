import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/status_request.dart';

/// Reusable generic base controller for paginated and searchable lists.
/// Standardizes scroll listeners, debounce, page indexing, and loading states.
abstract class BasePaginationController<T> extends GetxController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  StatuesRequest statuesRequest = StatuesRequest.none;

  List<T> items = [];
  List<T> searchList = [];

  bool isSearch = false;
  bool more = false;
  int index = 1;
  bool moreSearch = false;
  int indexSearch = 1;

  bool isLoadingMore = false;
  bool isLoadingMoreSearch = false;
  bool isLoadingSearch = false;

  Timer? debounceTimer;
  int searchRequestId = 0;

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
  }

  /// Sets up threshold scroll listener triggering next page load at 200px before bottom
  void setupScrollListener({double threshold = 200}) {
    scrollController.addListener(() {
      if (scrollController.hasClients &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - threshold) {
        if (isSearch) {
          loadMoreSearchResults();
        } else {
          loadMoreItems();
        }
      }
    });
  }

  Future<void> loadMoreItems();
  Future<void> loadMoreSearchResults();
  Future<void> refreshItems();

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    debounceTimer?.cancel();
    super.onClose();
  }
}
