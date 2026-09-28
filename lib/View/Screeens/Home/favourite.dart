import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/product_info.dart';
import 'package:tharwat_pharmacy/View/Screeens/Notification/notificatio_page.dart';
import 'package:tharwat_pharmacy/View/Widget/Favourite/app_bar_fav_page.dart';
import 'package:tharwat_pharmacy/View/Widget/Notification/no_notify_data.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/product_widget.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FavouriteController());
    HomeController homeController = Get.put(HomeController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeController.changePage(0);
          homeController.choose_1 = true;
          homeController.choose_2 = false;
        });
      },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<FavouriteController>(
          builder: (controller) => RefreshIndicator(
            onRefresh: controller.refreshFavItems,
            child: Column(
              children: [
                AppBarFavWidget(
                  onPressBack: () {
                    homeController.goToHome(0, {});
                  },
                  onPressNotify: () {
                    Get.to(() => const NotificatioPage());
                  },
                ),
                Expanded(
                  child: FutureBuilder<List<ProductModel>>(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget(height: 80.h);
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return SingleChildScrollView(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 60.h,
                            child: NoNotifyDataWidget(
                              image: AppImages.noFavImage,
                              title: "No Favourite",
                              body:
                                  "You can add an item to your favourites by clicking 'Heart Icon'",
                            ),
                          ),
                        );
                      } else {
                        return GridView.builder(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.favItems.length +
                              (controller.isLoadingMore ? 2 : 0),
                          padding: EdgeInsets.only(
                              left: 5.w, right: 5.w, bottom: 10.w, top: 3.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .71,
                            crossAxisSpacing: 4.w,
                            mainAxisSpacing: 4.w,
                          ),
                          itemBuilder: (context, index) {
                            if (index >= controller.favItems.length) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final product = controller.favItems[index];
                            return ProductWidget(
                              body: product.itmNameEn ?? "",
                              decorationImage: product.primaryImage == null
                                  ? AssetImage(AppImages.noImage)
                                      as ImageProvider
                                  : CachedNetworkImageProvider(
                                      "${AppApi.imgUrl}/${product.primaryImage}"),
                              fav: true,
                              onPressFav: () => controller
                                  .removeItemFromFav(product.id.toString()),
                              onPressShop: () {
                                Get.to(() => const ProductInfo(), arguments: {
                                  "id": product.id.toString(),
                                  "product": product
                                });
                              },
                              price: product.itmSellPrice ?? "0",
                              title: product.itmNameEn ?? "",
                            );
                          },
                        );
                      }
                    },
                    future: controller.favItemsFuture,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
