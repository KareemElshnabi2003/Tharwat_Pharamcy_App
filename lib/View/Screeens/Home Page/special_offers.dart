import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/special_offers_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/special_offers_products.dart';
import 'package:tharwat_pharmacy/View/Screeens/Notification/notificatio_page.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/no_data.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/special_card.dart';
import 'package:tharwat_pharmacy/main.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SpecialOffersController());

    return Scaffold(
      backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
          ? LightMode.nightColor
          : LightMode.whiteColor,
      body: GetBuilder<SpecialOffersController>(
        builder: (controller) => Column(
          children: [
            AppBarWidget(
              title: "Special Offers",
              onPressBack: () {
                Get.back();
              },
              onPressNotify: () {
                Get.to(() => const NotificatioPage());
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshOffersPage();
                },
                child: controller.statuesRequest == StatuesRequest.loading &&
                        controller.offers.isEmpty
                    ? LoadingWidget(height:80.h)
                    : controller.offers.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 80.h,
                              child: Center(
                                child: NoDataWidget(text: "No Offers"),
                              ),
                            ),
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),

                            controller: controller
                                .offersScrollController, // 🔥 Scroll controller
                            separatorBuilder: (context, index) => SizedBox(
                              height: 3.h,
                            ),
                            padding: EdgeInsets.only(top: 3.h, bottom: 2.h),
                            itemCount: controller.offers.length +
                                (controller.isLoadingMoreOffers ? 1 : 0) +
                                (!controller.moreOffers &&
                                        controller.offers.isNotEmpty
                                    ? 1
                                    : 0),
                            shrinkWrap: false,
                            itemBuilder: (context, index) {
                              // Loading indicator for more offers
                              if (index == controller.offers.length &&
                                  controller.isLoadingMoreOffers) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              // End of results message
                              if (index == controller.offers.length &&
                                  !controller.moreOffers) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: Center(
                                    child: Text(
                                      "No more offers",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Offer card
                              return SpecialCardWidget(
                                decorationImage:
                                    "${AppApi.imgUrl}/${controller.offers[index].image}",
                                titleBTN_1: controller.offers[index].name??"",
                                onPressBTN_2: () async {
                                  await controller.getOfferProducts();
                                  Get.to(() => const SpecialOffersProducts(),
                                      arguments: {
                                        "id": controller.offers[index].id
                                            .toString()
                                      });
                                },
                                descripe: controller.offers[index].description??'',
                                offer: controller.offers[index].type??"",
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
