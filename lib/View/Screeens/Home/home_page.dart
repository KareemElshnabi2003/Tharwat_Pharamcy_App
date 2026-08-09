import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_page_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Data/Model/Home/home_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/categories.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/category_products.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/featured_products.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/filter.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/most_orders.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/my_cart_page.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/product_info.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/special_offers.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/special_offers_products.dart';
import 'package:tharwat_pharmacy/View/Screeens/Notification/notificatio_page.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/title_section_home.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/top_page_home.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/category_card.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/no_data.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/product_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/special_card.dart';
import 'package:tharwat_pharmacy/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FavouriteController());
    HomeController homeController = Get.put(HomeController());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        messageErrorWithButton(
          "Warning",
          "Are you sure you want to close app",
              () { exit(0); },
          "Close",
        );
      },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<HomePageController>(
          init: HomePageController(),
          builder: (controller) => RefreshIndicator(
            onRefresh: () async {
              controller.refreshPage();
            },
            child: SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                children: [
                  TopPageHomeWidget(
                    title: "${sharedPreferences!.getString("countryName") ?? ""} , ${sharedPreferences!.getString("cityName") ?? ""}",
                    onPressShop: () => Get.to(() => const MyCartPage()),
                    onPressNotify: () => Get.to(() => const NotificatioPage()),
                    onPressFilter: () => Get.to(() => const Filter()),
                    controller: controller.searchController,
                    onChange: (value) => controller.checkSearch(value),
                  ),
                  SizedBox(height: 3.h),

                  controller.isSearch == true
                      ? controller.statuesRequest == StatuesRequest.loading
                      ? LoadingWidget(height: 80.h) // تعديل
                      : controller.searchList.isEmpty
                      ? const Center(child: NoDataWidget(text: "No Items .")) // تعديل
                      : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5.w, left: 5.w),
                        child: GridView.builder(
                          itemCount: controller.searchList.length,
                          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .68,
                            crossAxisSpacing: 4.w,
                            mainAxisSpacing: 4.w,
                          ),
                          itemBuilder: (context, index) => GetBuilder<FavouriteController>(
                            builder: (favController) => ProductWidget( // تعديل
                              body: controller.searchList[index].itmNameEn ?? "",
                              decorationImage: controller.searchList[index].primaryImage == null
                                  ? AssetImage(AppImages.noImage) as ImageProvider
                                  : CachedNetworkImageProvider("${AppApi.imgUrl}/${controller.searchList[index].primaryImage}"),
                              fav: favController.favProductsId.contains(controller.searchList[index].id),
                              onPressFav: () {
                                if (favController.favProductsId.contains(controller.searchList[index].id)) {
                                  favController.notFavProducts(controller.searchList[index].id);
                                } else {
                                  favController.favProducts(controller.searchList[index].id);
                                }
                              },
                              onPressShop: () {
                                Get.to(() => const ProductInfo(),
                                  arguments: {
                                    "id": controller.searchList[index].id.toString(),
                                    "product": controller.searchList[index]
                                  },
                                );
                              },
                              price: controller.searchList[index].itmSellPrice ?? "0",
                              rate: 5,
                              title: controller.searchList[index].itmNameEn ?? "",
                            ),
                          ),
                        ),
                      ),
                      if (controller.isLoadingMore)
                        Container(padding: EdgeInsets.symmetric(vertical: 2.h), child: const Center(child: CircularProgressIndicator())),
                      if (!controller.more && controller.searchList.isNotEmpty)
                        Container(padding: EdgeInsets.symmetric(vertical: 2.h), child: Text("No more products", style: TextStyle(color: Colors.grey[600], fontSize: 14))),
                      SizedBox(height: 2.h),
                    ],
                  )
                      : FutureBuilder<HomeModel?>(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget(height: 80.h);
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const NoDataWidget(text: 'no Data');
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleSectionHomeWidget(
                              margin: true,
                              onPressSeeAll: () {
                                Get.to(() => const SpecialOffers(), arguments: {"id": ''});
                              },
                              title: "Special Offers",
                            ),
                            SizedBox(height: 2.h),
                            snapshot.data!.data!.offers!.isEmpty
                                ? const Center(child: NoDataWidget(text: "No Offers"))
                                : SizedBox(
                              width: 100.w,
                              height: 24.h,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.data!.offers!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => SpecialCardWidget(
                                  descripe: snapshot.data!.data!.offers![index].description??"",
                                  offer: snapshot.data!.data!.offers![index].type??"",
                                  decorationImage:  "${AppApi.imgUrl}/${snapshot.data!.data!.offers![index].image}",
                                  titleBTN_1: snapshot.data!.data!.offers![index].name??"",
                                  onPressBTN_2: () {
                                    Get.to(() => const SpecialOffersProducts(),
                                        arguments: {
                                          "id": snapshot.data!.data!.offers![index].id.toString()
                                        });
                                    homeController.choose_1 = false;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),

                            TitleSectionHomeWidget(
                              margin: true,
                              onPressSeeAll: () {
                                Get.to(() => const CategoriesPage());
                              },
                              title: "Category",
                            ),
                            SizedBox(height: 2.h),
                            snapshot.data!.data!.categories!.isEmpty
                                ? const Center(child: NoDataWidget(text: "No Categories Yet."))
                                : Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              width: 100.w,
                              height: 15.h,
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(width: 4.5.w),
                                padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.data!.categories!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => CategoryCardWidget( // تعديل
                                  onPress: () {
                                    Get.to(() => const CategoryProducts(), arguments: {
                                      "name": snapshot.data!.data!.categories![index].name,
                                      "id": snapshot.data!.data!.categories![index].id.toString()
                                    });
                                  },
                                  text: snapshot.data!.data!.categories![index].name ?? "",
                                  image: snapshot.data!.data!.categories![index].icon == null
                                      ? Image.asset(AppImages.noImage, width: 10.w, height: 10.w, fit: BoxFit.cover)
                                      : snapshot.data!.data!.categories![index].icon!.contains(".svg")
                                      ? SvgPicture.network("${AppApi.imgUrl}/${snapshot.data!.data!.categories![index].icon}", width: 9.w, height: 9.w, fit: BoxFit.fill)
                                      : CachedNetworkImage(imageUrl: "${AppApi.imgUrl}/${snapshot.data!.data!.categories![index].icon}", width: 10.w, height: 10.w, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),

                            TitleSectionHomeWidget(
                              margin: true,
                              onPressSeeAll: () {
                                // homeController.changePage(4);
                                // homeController.choose_1 = false;
                                Get.to(() => const FeaturedProducts());

                              },
                              title: "Featured Products",
                            ),
                            SizedBox(height: 2.h),
                            snapshot.data!.data!.trendingProducts!.data!.isEmpty
                                ? const Center(child: NoDataWidget(text: "No Products Yet."))
                                : Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              width: 100.w,
                              height: 31.h,
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(width: 4.w),
                                padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.data!.trendingProducts!.data!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => GetBuilder<FavouriteController>(
                                  builder: (favController) => ProductWidget( // تعديل
                                    onPressFav: () {
                                      var id = snapshot.data!.data!.trendingProducts!.data![index].id;
                                      if (favController.favProductsId.contains(id)) {
                                        favController.notFavProducts(id);
                                      } else {
                                        favController.favProducts(id);
                                      }
                                    },
                                    decorationImage: snapshot.data!.data!.trendingProducts!.data![index].primaryImage == null
                                        ? AssetImage(AppImages.noImage) as ImageProvider
                                        : CachedNetworkImageProvider("${AppApi.imgUrl}/${snapshot.data!.data!.trendingProducts!.data![index].primaryImage}"),
                                    title: snapshot.data!.data!.trendingProducts!.data![index].itmNameEn ?? "",
                                    price: snapshot.data!.data!.trendingProducts!.data![index].itmSellPrice ?? "0",
                                    body: snapshot.data!.data!.trendingProducts!.data![index].description ?? "",
                                    fav: favController.favProductsId.contains(snapshot.data!.data!.trendingProducts!.data![index].id),
                                    onPressShop: () {
                                      Get.to(() => const ProductInfo(), arguments: {
                                        "id": snapshot.data!.data!.trendingProducts!.data![index].id.toString(),
                                        "product": snapshot.data!.data!.trendingProducts!.data![index]
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),

                            TitleSectionHomeWidget(
                              margin: true,
                              onPressSeeAll: () {
                                // homeController.changePage(5);
                                // homeController.choose_1 = false;
                                Get.to(() => const MostOrders());
                              },
                              title: "Most Ordered",
                            ),
                            SizedBox(height: 2.h),
                            snapshot.data!.data!.mostOrderedProducts!.data!.isEmpty
                                ? const Center(child: NoDataWidget(text: "No Products Yet."))
                                : Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              width: 100.w,
                              height: 31.h,
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(width: 4.w),
                                padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.data!.mostOrderedProducts!.data!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => GetBuilder<FavouriteController>(
                                  builder: (favController) => ProductWidget( // تعديل
                                    onPressFav: () {
                                      var id = snapshot.data!.data!.mostOrderedProducts!.data![index].id;
                                      if (favController.favProductsId.contains(id) || snapshot.data!.data!.mostOrderedProducts!.data![index].isFavourite == true) {
                                        favController.notFavProducts(id);
                                      } else {
                                        favController.favProducts(id);
                                      }
                                    },
                                    decorationImage: snapshot.data!.data!.mostOrderedProducts!.data![index].primaryImage == null
                                        ? AssetImage(AppImages.noImage) as ImageProvider
                                        : CachedNetworkImageProvider("${AppApi.imgUrl}/${snapshot.data!.data!.mostOrderedProducts!.data![index].primaryImage}"),
                                    title: snapshot.data!.data!.mostOrderedProducts!.data![index].itmNameEn ?? "",
                                    price: snapshot.data!.data!.mostOrderedProducts!.data![index].itmSellPrice ?? "0",
                                    body: snapshot.data!.data!.mostOrderedProducts!.data![index].description ?? "",
                                    fav: favController.favProductsId.contains(snapshot.data!.data!.mostOrderedProducts!.data![index].id),
                                    onPressShop: () {
                                      Get.to(() => const ProductInfo(), arguments: {
                                        "id": snapshot.data!.data!.mostOrderedProducts!.data![index].id.toString(),
                                        "product": snapshot.data!.data!.mostOrderedProducts!.data![index]
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        );
                      }
                    },
                    future:controller.homeDataFuture,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}