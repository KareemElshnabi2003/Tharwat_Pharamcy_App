import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/featured_products_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/filter.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/product_info.dart';
import 'package:tharwat_pharmacy/View/Screeens/Notification/notificatio_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/no_data.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/product_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/search_filter_widget.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FeaturedProductsController());
    HomeController homeController = Get.put(HomeController());
    Get.put(FavouriteController());

    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<FeaturedProductsController>(
        builder: (controller) => Column(
          children: [
            AppBarWidget(
              title: "Featured Products",
              onPressBack: () {
                homeController.goToHome(0, {});
                homeController.change_1();
              },
              onPressNotify: () => Get.to(() => const NotificatioPage()),
            ),
            Padding(
              padding: EdgeInsets.only(right: 7.w, left: 7.w, top: 3.h),
              child: SearchFilterWidget(
                onPressFilter: () => Get.to(() => const Filter()),
                onChange: (search) => controller.checkSearchFeature(search),
                controller: controller.searchController,
                colorFill: ThemeService.primaryColor,
                colorIconSearch: LightMode.whiteColor,
                colorText: LightMode.whiteColor,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: controller.isSearch
                    ? _buildSearchResults(controller)
                    : _buildFeaturedProducts(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(FeaturedProductsController controller) {
    if (controller.statuesRequest == StatuesRequest.loading &&
        controller.searchList.isEmpty) return LoadingWidget(height: 60.h);
    if (controller.searchList.isEmpty)
      return const Center(child: NoDataWidget(text: "No Items."));
    return ListView(
      controller: controller.scrollController,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.searchList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .72,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.w),
          itemBuilder: (context, index) => GetBuilder<FavouriteController>(
            builder: (fav) => ProductWidget(
              body: controller.searchList[index].itmNameEn ?? "",
              decorationImage: controller.searchList[index].primaryImage == null
                  ? AssetImage(AppImages.noImage)
                  : CachedNetworkImageProvider(
                      "${AppApi.imgUrl}/${controller.searchList[index].primaryImage}"),
              fav: fav.favProductsId.contains(controller.searchList[index].id),
              onPressFav: () =>
                  fav.favProductsId.contains(controller.searchList[index].id)
                      ? fav.notFavProducts(controller.searchList[index].id)
                      : fav.favProducts(controller.searchList[index].id),
              onPressShop: () => Get.to(() => const ProductInfo(), arguments: {
                "id": controller.searchList[index].id.toString(),
                "product": controller.searchList[index]
              }),
              price: controller.searchList[index].itmSellPrice ?? "0",
              title: controller.searchList[index].itmNameEn ?? "",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProducts(FeaturedProductsController controller) {
    if (controller.statuesRequest == StatuesRequest.loading &&
        controller.trendProducts.isEmpty) return LoadingWidget(height: 60.h);
    if (controller.trendProducts.isEmpty)
      return const Center(child: NoDataWidget(text: "No Products Yet"));
    return ListView(
      padding: EdgeInsets.only(right: 7.w, left: 7.w),
      controller: controller.scrollController,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.trendProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .72,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.w),
          itemBuilder: (context, index) => GetBuilder<FavouriteController>(
            builder: (fav) => ProductWidget(
              body: controller.trendProducts[index].itmNameEn ?? "",
              decorationImage: controller.trendProducts[index].primaryImage ==
                      null
                  ? AssetImage(AppImages.noImage)
                  : CachedNetworkImageProvider(
                      "${AppApi.imgUrl}/${controller.trendProducts[index].primaryImage}"),
              fav: fav.favProductsId
                  .contains(controller.trendProducts[index].id),
              onPressFav: () =>
                  fav.favProductsId.contains(controller.trendProducts[index].id)
                      ? fav.notFavProducts(controller.trendProducts[index].id)
                      : fav.favProducts(controller.trendProducts[index].id),
              onPressShop: () => Get.to(() => const ProductInfo(), arguments: {
                "id": controller.trendProducts[index].id.toString(),
                "product": controller.trendProducts[index]
              }),
              price: controller.trendProducts[index].itmSellPrice ?? "0",
              title: controller.trendProducts[index].itmNameEn ?? "",
            ),
          ),
        ),
      ],
    );
  }
}
