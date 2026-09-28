import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/product_info_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_product_info.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/buttom_product_info_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/product_info_section.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
          ? LightMode.nightColor
          : LightMode.whiteColor,
      body: GetBuilder<ProductInfoController>(
        init: ProductInfoController(),
        builder: (controller) => Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              color: sharedPreferences!.getString("Mood") == "Dark"
                  ? LightMode.nightColor
                  : LightMode.whiteColor,
              height: 98.h,
              margin: EdgeInsets.only(right: 3.w, left: 3.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // autoSliderImage(
                    //   images: [
                    Container(
                        margin: EdgeInsets.only(top: 6.h),
                        width: 90.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4.w),
                              bottomRight: Radius.circular(4.w)),
                          image: DecorationImage(
                            image: controller.productModel!.primaryImage == null
                                ? AssetImage(
                                    AppImages.noImage,
                                  )
                                : CachedNetworkImageProvider(
                                    "${AppApi.imgUrl}/${controller.productModel!.primaryImage!}"),
                            fit: BoxFit.fill,
                          ),
                        )),
                    //],
                    //),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 2.w, left: 2.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextNormalWidget(
                                        text:
                                            controller.productModel!.itmNameEn,
                                        color: sharedPreferences!
                                                    .getString("Mood") ==
                                                "Dark"
                                            ? LightMode.whiteColor
                                            : LightMode.blackColor,
                                        size: 4.5.w,
                                        weight: FontWeight.bold),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            const Divider(
                              color: LightMode.mainColor,
                              thickness: 1.5,
                            ),
                            ProductInfoSectionWidget(
                                body:
                                    "${controller.productModel!.itmScientificN1} - ${controller.productModel!.itmScientificN2}",
                                title: "Scientific Name",
                                moreRead: controller.readMore_1,
                                onTap: () {
                                  controller.change_1();
                                }),
                            SizedBox(
                              height: 1.h,
                            ),
                            const Divider(
                              color: LightMode.mainColor,
                              thickness: 1.5,
                            ),
                            ProductInfoSectionWidget(
                                body: "${controller.productModel!.description}",
                                title: "Discription",
                                moreRead: controller.readMore_2,
                                onTap: () {
                                  controller.change_2();
                                }),
                            SizedBox(
                              height: 1.h,
                            ),
                            const Divider(
                              color: LightMode.mainColor,
                              thickness: 1.5,
                            ),
                            ProductInfoSectionWidget(
                                body: "${controller.productModel!.itnlCode}",
                                title: "International Code",
                                moreRead: controller.readMore_3,
                                onTap: () {
                                  controller.change_3();
                                }),
                            SizedBox(
                              height: 1.h,
                            ),
                            const Divider(
                              color: LightMode.mainColor,
                              thickness: 1.5,
                            ),
                            ProductInfoSectionWidget(
                                body:
                                    "${controller.productModel!.stoName} - ${controller.productModel!.stoQtyMedium} ${controller.productModel!.uNameMedium}",
                                title: "Branch Availability",
                                moreRead: controller.readMore_4,
                                onTap: () {
                                  controller.change_4();
                                }),
                            SizedBox(
                              height: 1.h,
                            ),
                            const Divider(
                              color: LightMode.mainColor,
                              thickness: 1.5,
                            ),
                            ProductInfoSectionWidget(
                                body:
                                    "${controller.productModel!.companyNameEn}",
                                title: "Manufacture Company",
                                moreRead: controller.readMore_5,
                                onTap: () {
                                  controller.change_5();
                                }),
                            SizedBox(
                              height: 1.h,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                child: AppBarProductInfoWidget(
                    fav: controller.favProductsId
                            .contains(controller.productModel!.id)
                        ? true
                        : false,
                    onPressBack: () {
                      Get.back();
                    },
                    onPressFav: () {
                      if (controller.favProductsId
                          .contains(controller.productModel!.id)) {
                        controller.notFavProducts(controller.productModel!.id);
                      } else {
                        controller.favProducts(controller.productModel!.id);
                      }
                    })),
            Positioned(
                bottom: 0,
                right: 3.w,
                left: 3.w,
                child: BottomProductInfoWidget(
                    onTap: () {
                      controller.addToCart();
                    },
                    price: controller.productModel!.itmSellPrice ?? "")),
          ],
        ),
      ),
    );
  }
}
