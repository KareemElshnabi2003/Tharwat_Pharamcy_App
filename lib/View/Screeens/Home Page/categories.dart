import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Categories/categories_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/category_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/category_products.dart';
import 'package:tharwat_pharmacy/View/Screeens/Notification/notificatio_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/category_card.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/no_data.dart';
import 'package:tharwat_pharmacy/main.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Scaffold(
      backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
          ? LightMode.nightColor
          : LightMode.whiteColor,
      body: GetBuilder<CategoriesController>(
        init: CategoriesController(),
        builder: (controller) => Column(
          children: [
            // App Bar
            AppBarWidget(
              title: "Categories",
              onPressBack: () {
                homeController.goToHome(0, {});
              },
              onPressNotify: () {
                Get.to(() => const NotificatioPage());
              },
            ),

            SizedBox(height: 3.h),

            // Categories Horizontal List
            SizedBox(
              height: 6.h,
              width: 100.w,
              child: ListView.separated(
                padding: EdgeInsets.only(right: 5.w, left: 5.w),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => ButtonWidget(
                  colorBorder: LightMode.mainColor,
                  colorFill:
                      controller.indexCat == controller.categories[index].id
                          ? sharedPreferences!.getString("Mood") == "Dark"
                              ? LightMode.darkMainColor
                              : LightMode.mainColor
                          : sharedPreferences!.getString("Mood") == "Dark"
                              ? LightMode.nightColor
                              : LightMode.whiteColor,
                  colorText:
                      controller.indexCat == controller.categories[index].id
                          ? LightMode.whiteColor
                          : LightMode.mainColor,
                  width: 30.w,
                  text: controller.categories[index].name ?? "",
                  onPress: () {
                    controller.changeIndex(controller.categories[index].id);
                  },
                  size: 3.5.w,
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: controller.categories.length,
              ),
            ),

            // Subcategories Grid with Infinite Scroll
            Expanded(
              child: _buildSubCategories(controller),
            ),
          ],
        ),
      ),
    );
  }

  /// Build subcategories grid with infinite scroll and pull-to-refresh
  Widget _buildSubCategories(CategoriesController controller) {
    if (controller.statuesRequest == StatuesRequest.loading &&
        controller.subCategories.isEmpty) {
      return LoadingWidget(height: 80.h);
    }

    if (controller.subCategories.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await controller.refreshSubCategories();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 60.h,
            child: const Center(
              child: NoDataWidget(text: "No Sub Category"),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshSubCategories();
      },
      child: GridView.builder(
        controller: controller.scrollController,
        itemCount: controller.subCategories.length,
        padding: EdgeInsets.only(top: 3.h, right: 5.w, left: 5.w, bottom: 2.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: .55,
          crossAxisCount: 4,
          mainAxisSpacing: 3.w,
          crossAxisSpacing: 3.w,
        ),
        itemBuilder: (context, index) {
          // Show loading indicator at the end when loading more
          if (index == controller.subCategories.length - 1 &&
              controller.isLoadingMore) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryCardWidget(
                  onPress: () {
                    Get.to(() => const CategoryProducts(), arguments: {
                      "name": controller.subCategories[index].name,
                      "id": controller.subCategories[index].id.toString()
                    });
                  },
                  image: _buildCategoryImage(controller.subCategories[index]),
                  text: controller.subCategories[index].name ?? "",
                ),
              ],
            );
          }

          return CategoryCardWidget(
            onPress: () {
              Get.to(() => const CategoryProducts(), arguments: {
                "name": controller.subCategories[index].name,
                "id": controller.subCategories[index].id.toString()
              });
            },
            image: _buildCategoryImage(controller.subCategories[index]),
            text: controller.subCategories[index].name ?? "",
          );
        },
      ),
    );
  }

  /// Build category image widget
  Widget _buildCategoryImage(CategoryModel category) {
    if (category.icon == null) {
      return Image.asset(
        AppImages.noImage,
        fit: BoxFit.cover,
        width: 10.w,
        height: 10.w,
      );
    }

    if (category.icon!.contains(".svg")) {
      return SvgPicture.network(
        "${AppApi.imgUrl}/${category.icon}",
        width: 9.w,
        height: 9.w,
        fit: BoxFit.fill,
      );
    }

    return CachedNetworkImage(
      imageUrl: "${AppApi.imgUrl}/${category.icon}",
      width: 10.w,
      height: 10.w,
      fit: BoxFit.cover,
    );
  }
}
