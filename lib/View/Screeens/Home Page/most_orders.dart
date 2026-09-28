import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/most_orders_controller.dart';
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

class MostOrders extends StatelessWidget {
  const MostOrders({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MostOrdersController());
    Get.put(FavouriteController());
    HomeController homeController = Get.put(HomeController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeController.goToHome(0, {});
          homeController.change_1();
        });
      },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<MostOrdersController>(
          builder: (controller) => Column(
            children: [
              AppBarWidget(
                onPressBack: () {
                  homeController.goToHome(0, {});
                  homeController.change_1();
                },
                onPressNotify: () => Get.to(() => const NotificatioPage()),
                title: "Most Orders",
              ),
              Padding(
                padding: EdgeInsets.only(right: 7.w, left: 7.w, top: 3.h),
                child: SearchFilterWidget(
                  onPressFilter: () => Get.to(() => const Filter()),
                  onChange: (search) => controller.checkSearchMost(search),
                  controller: controller.searchController,
                  colorBorderIconFilter: LightMode.mainColor,
                  colorFill: ThemeService.primaryColor,
                  colorIconFilter: LightMode.whiteColor,
                  colorIconSearch: LightMode.whiteColor,
                  colorText: LightMode.whiteColor,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshProducts,
                  child: controller.isSearch
                      ? _buildList(controller.searchList, controller)
                      : _buildList(controller.mostOrderProducts, controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List list, MostOrdersController controller) {
    if (controller.statuesRequest == StatuesRequest.loading && list.isEmpty) {
      return LoadingWidget(height: 60.h);
    }
    if (list.isEmpty) {
      return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
              height: 60.h,
              child: const Center(child: NoDataWidget(text: "No Items."))));
    }

    return GridView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .7,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.w),
      itemCount: list.length,
      itemBuilder: (context, index) => GetBuilder<FavouriteController>(
        id: 'fav_${list[index].id}',
        builder: (fav) => ProductWidget(
          body: list[index].itmNameEn ?? "",
          decorationImage: list[index].primaryImage == null
              ? AssetImage(AppImages.noImage)
              : CachedNetworkImageProvider(
                  "${AppApi.imgUrl}/${list[index].primaryImage}"),
          fav: fav.favProductsId.contains(list[index].id),
          onPressFav: () => fav.favProductsId.contains(list[index].id)
              ? fav.notFavProducts(list[index].id)
              : fav.favProducts(list[index].id),
          onPressShop: () => Get.to(() => const ProductInfo(), arguments: {
            "id": list[index].id.toString(),
            "product": list[index]
          }),
          price: list[index].itmSellPrice ?? "0",
          title: list[index].itmNameEn ?? "",
        ),
      ),
    );
  }
}
