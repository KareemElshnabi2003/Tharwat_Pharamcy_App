import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/special_offers_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/filter.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/product_info.dart';
import 'package:tharwat_pharmacy/View/Screeens/Notification/notificatio_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/no_data.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/product_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/search_filter_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class SpecialOffersProducts extends StatelessWidget {
  const SpecialOffersProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
          ? LightMode.nightColor
          : LightMode.whiteColor,
      body: GetBuilder<SpecialOffersController>(
        init: SpecialOffersController(),
        builder: (controller) => Column(
          children: [
            // App Bar
            AppBarWidget(
              title: "Special Offers",
              onPressNotify: () {
                Get.to(() => const NotificatioPage());
              },
              onPressBack: () {
                Get.back();
              },
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.only(right: 7.w, left: 7.w, top: 3.h),
              child: SearchFilterWidget(
                onPressFilter: () {
                  Get.to(() => const Filter());
                },
                onChange: (search) {
                  controller.checkSearchOffer(search);
                },
                controller: controller.searchController,
                colorBorderIconFilter: LightMode.mainColor,
                colorFill: sharedPreferences!.getString("Mood") == "Dark"
                    ? LightMode.darkMainColor
                    : LightMode.mainColor,
                colorIconFilter: LightMode.whiteColor,
                colorIconSearch: LightMode.whiteColor,
                colorText: LightMode.whiteColor,
              ),
            ),

            // Products Grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshProductsPage();
                },
                child: controller.isSearch
                    ? _buildSearchResults(controller)
                    : _buildOfferProducts(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build search results section
  Widget _buildSearchResults(SpecialOffersController controller) {
    if (controller.statuesRequest == StatuesRequest.loading &&
        controller.searchList.isEmpty) {
      return LoadingWidget(height: 63.h);
    }

    if (controller.searchList.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 60.h,
          child: const Center(
            child: NoDataWidget(text: "No Items ."),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: controller.productsScrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // ✅ REMOVED FutureBuilder - just display the data directly
          Container(
            margin: EdgeInsets.only(right: 5.w, left: 5.w, top: 2.h),
            child: GridView.builder(
              itemCount: controller.searchList.length,
              padding: EdgeInsets.only(bottom: 2.h),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .71,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 4.w,
              ),
              itemBuilder: (context, index) => GetBuilder<FavouriteController>(
                id: 'fav_${controller.searchList[index].id}',
                builder: (favController) => ProductWidget(
                  body: controller.searchList[index].itmNameEn ?? "",
                  decorationImage: controller.searchList[index].primaryImage ==
                          null
                      ? AssetImage(AppImages.noImage)
                      : CachedNetworkImageProvider(
                          "${AppApi.imgUrl}/${controller.searchList[index].primaryImage}"),
                  fav: favController.favProductsId
                          .contains(controller.searchList[index].id)
                      ? true
                      : false,
                  onPressFav: () {
                    favController.favProductsId
                            .contains(controller.searchList[index].id)
                        ? favController
                            .notFavProducts(controller.searchList[index].id)
                        : favController
                            .favProducts(controller.searchList[index].id);
                  },
                  onPressShop: () {
                    Get.to(
                      () => const ProductInfo(),
                      arguments: {
                        "id": controller.searchList[index].id.toString(),
                        "product": controller.searchList[index]
                      },
                    );
                  },
                  price: controller.searchList[index].itmSellPrice ?? "",
                  rate: 5,
                  title: controller.searchList[index].itmNameEn ?? "",
                ),
              ),
            ),
          ),

          // 🔄 Loading indicator for more search results
          if (controller.isLoadingMoreSearch)
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // 📝 End of search results message
          if (!controller.moreSearch && controller.searchList.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                "No more products",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build offer products section
  Widget _buildOfferProducts(SpecialOffersController controller) {
    if (controller.statuesRequest == StatuesRequest.loading &&
        controller.offerProducts.isEmpty) {
      return LoadingWidget(height: 62.h);
    }

    if (controller.offerProducts.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 60.h,
          child: const Center(
            child: NoDataWidget(text: "No Products Yet"),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: controller.productsScrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // ✅ REMOVED FutureBuilder - just display the data directly
          Container(
            margin: EdgeInsets.only(right: 5.w, left: 5.w, top: 2.h),
            child: GridView.builder(
              itemCount: controller.offerProducts.length,
              padding: EdgeInsets.only(bottom: 2.h),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .71,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 4.w,
              ),
              itemBuilder: (context, index) => GetBuilder<FavouriteController>(
                id: 'fav_${controller.offerProducts[index].id}',
                builder: (favController) => ProductWidget(
                  body: controller.offerProducts[index].itmNameEn ?? "",
                  decorationImage: controller
                              .offerProducts[index].primaryImage ==
                          null
                      ? AssetImage(AppImages.noImage)
                      : CachedNetworkImageProvider(
                          "${AppApi.imgUrl}/${controller.offerProducts[index].primaryImage}"),
                  fav: favController.favProductsId
                          .contains(controller.offerProducts[index].id)
                      ? true
                      : false,
                  onPressFav: () {
                    favController.favProductsId
                            .contains(controller.offerProducts[index].id)
                        ? favController
                            .notFavProducts(controller.offerProducts[index].id)
                        : favController
                            .favProducts(controller.offerProducts[index].id);
                  },
                  onPressShop: () {
                    Get.to(
                      () => const ProductInfo(),
                      arguments: {
                        "id": controller.offerProducts[index].id.toString(),
                        "product": controller.offerProducts[index]
                      },
                    );
                  },
                  price: controller.offerProducts[index].itmSellPrice ?? "",
                  rate: 5,
                  title: controller.offerProducts[index].itmNameEn ?? "",
                ),
              ),
            ),
          ),

          // 🔄 Loading indicator for more products
          if (controller.isLoadingMore)
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // 📝 End of products message
          if (!controller.more && controller.offerProducts.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                "No more products",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
