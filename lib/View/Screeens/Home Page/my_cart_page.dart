import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/my_cart_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Data/Model/Cart/cart_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Cart/choose_payment.dart';
import 'package:tharwat_pharmacy/View/Widget/MyCart/cart_item_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/MyCart/row_price_cart_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/no_data.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class MyCartPage extends StatelessWidget {
  const MyCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    MyCartController myCartController = Get.put(MyCartController());

    return Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<MyCartController>(
          builder: (controller) => SingleChildScrollView(
            child: Column(
              children: [
                AppBarWidget(
                    notify: false,
                    onPressBack: () {
                      Get.back();
                    },
                    title: "My Cart"),
                controller.statuesRequest == StatuesRequest.socketException
                    ? const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                            child:
                                NoDataWidget(text: "No Internet Connection")))
                    : FutureBuilder<CartModel?>(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingWidget(height: 80.h);
                          } else if (snapshot.connectionState ==
                              ConnectionState.none) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: NoDataWidget(
                                      text: "No Internet Connection")),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.cartItems!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: NoDataWidget(
                                      text: "No Items Yet In Cart")),
                            );
                          } else {
                            return Column(
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 49.h,
                                  margin: EdgeInsets.only(
                                      right: 6.w, left: 6.w, top: 3.h),
                                  child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          ItemCartWidget(
                                              decorationImage: snapshot
                                                          .data!
                                                          .cartItems![index]
                                                          .product!
                                                          .primaryImage ==
                                                      null
                                                  ? AssetImage(AppImages.noImage)
                                                      as ImageProvider
                                                  : CachedNetworkImageProvider(
                                                      "${AppApi.imgUrl}/${snapshot.data!.cartItems![index].product!.primaryImage}"),
                                              name: snapshot
                                                      .data!
                                                      .cartItems![index]
                                                      .product!
                                                      .itmNameEn ??
                                                  "",
                                              body: snapshot
                                                      .data!
                                                      .cartItems![index]
                                                      .product!
                                                      .description ??
                                                  "",
                                              price: snapshot
                                                      .data!
                                                      .cartItems![index]
                                                      .product!
                                                      .itmSellPrice ??
                                                  "0",
                                              numOfItems:
                                                  snapshot.data!.cartItems![index].quantity ?? 1,
                                              onAdd: () {
                                                myCartController.increaseCart(
                                                    qtv: snapshot
                                                            .data!
                                                            .cartItems![index]
                                                            .quantity! +
                                                        1,
                                                    productId: snapshot.data!
                                                        .cartItems![index].id);
                                              },
                                              onRemove: () {
                                                if (snapshot
                                                        .data!
                                                        .cartItems![index]
                                                        .quantity ==
                                                    1) {
                                                  myCartController
                                                      .deleteFromCart(
                                                          productId: snapshot
                                                              .data!
                                                              .cartItems![index]
                                                              .id);
                                                } else {
                                                  myCartController.decreaseCart(
                                                      qtv: snapshot
                                                              .data!
                                                              .cartItems![index]
                                                              .quantity! -
                                                          1,
                                                      productId: snapshot
                                                          .data!
                                                          .cartItems![index]
                                                          .id);
                                                }
                                              }),
                                      separatorBuilder: (context, index) => SizedBox(height: 2.h),
                                      itemCount: snapshot.data!.cartItems!.length),
                                ),
                                SizedBox(height: 2.h),
                                Container(
                                  color: ThemeService.backgroundColor,
                                  margin:
                                      EdgeInsets.only(right: 5.w, left: 5.w),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 2.h),
                                        TextNormalWidget(
                                            text: "Order Details",
                                            color: LightMode.mainColor,
                                            size: 3.5.w,
                                            weight: FontWeight.w700),
                                        SizedBox(height: 2.h),
                                        RowPriceWidget(
                                            title: "Delivery",
                                            price: snapshot.data!.deliveryCost
                                                    ?.toString() ??
                                                '',
                                            total: false),
                                        SizedBox(height: 2.h),
                                        RowPriceWidget(
                                            title: "Cost",
                                            price: snapshot.data!.cost
                                                    ?.toString() ??
                                                '',
                                            total: false),
                                        SizedBox(height: 1.h),
                                        Divider(
                                          thickness: 2,
                                          color: ThemeService.isDark
                                              ? LightMode.whiteBlueColor
                                              : LightMode.blackColor,
                                        ),
                                        SizedBox(height: 1.h),
                                        RowPriceWidget(
                                            title: "Total Cost",
                                            price: snapshot.data!.totalCost
                                                    ?.toString() ??
                                                '',
                                            total: true),
                                        SizedBox(height: 2.h),
                                        ButtonWidget(
                                            colorBorder:
                                                ThemeService.primaryColor,
                                            colorText: LightMode.whiteColor,
                                            colorFill:
                                                ThemeService.primaryColor,
                                            onPress: () {
                                              Get.to(
                                                  () => const ChoosePayment(),
                                                  arguments: {
                                                    "totalCost": snapshot
                                                            .data!.totalCost ??
                                                        ""
                                                  });
                                            },
                                            text: "Next",
                                            size: 3.5.w,
                                            width: 100.w,
                                            margin: false),
                                        SizedBox(height: 2.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        future: myCartController.getCartData(),
                      ),
              ],
            ),
          ),
        ));
  }
}
