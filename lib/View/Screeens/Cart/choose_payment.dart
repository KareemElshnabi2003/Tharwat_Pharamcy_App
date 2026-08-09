import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Payment/choose_payment_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Screeens/Cart/check_out_page.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/type_user_choose.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';

class ChoosePayment extends StatelessWidget {
  const ChoosePayment({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChoosePaymentController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<ChoosePaymentController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              AppBarPageWidget(
                back: true,
                onPress: () => Get.back(),
                title: "Payment Methods",
                colorText: ThemeService.isDark ? LightMode.mainColor : LightMode.blackColor,
                colorIcon: ThemeService.isDark ? LightMode.mainColor : LightMode.blackColor,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SizedBox(
                  height: 85.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          TypeUserChooseWidget(
                              groubVal: controller.payment,
                              img: Image.asset(AppImages.cashImage, width: 7.w, height: 7.w, color: controller.payment == "cash" && ThemeService.isDark ? LightMode.whiteColor : null),
                              payment: true,
                              onChanged: (val) => controller.choose(val),
                              onTap: () => controller.choose("cash"),
                              typeUser: "cash",
                              choose: controller.payment == "cash"),
                          TypeUserChooseWidget(
                              groubVal: controller.payment,
                              img: Image.asset(AppImages.cardImage, width: 7.w, height: 7.w, color: controller.payment == "credit / debit card" && ThemeService.isDark ? LightMode.whiteBlueColor : null),
                              payment: true,
                              onChanged: (val) => controller.choose(val),
                              onTap: () => controller.choose("credit / debit card"),
                              typeUser: "credit / debit card",
                              choose: controller.payment == "credit / debit card"),
                          TypeUserChooseWidget(
                              groubVal: controller.payment,
                              img: Image.asset(AppImages.vodafoneImage, width: 7.w, height: 7.w, color: controller.payment == "vodafone cash" && ThemeService.isDark ? LightMode.whiteBlueColor : null),
                              payment: true,
                              onChanged: (val) => controller.choose(val),
                              onTap: () => controller.choose("vodafone cash"),
                              typeUser: "vodafone cash",
                              choose: controller.payment == "vodafone cash"),
                          TypeUserChooseWidget(
                              groubVal: controller.payment,
                              img: Image.asset(AppImages.instapayImage, width: 30.w, height: 7.w, color: (controller.payment == "" || controller.payment == "instapay") && ThemeService.isDark ? LightMode.whiteBlueColor : null),
                              payment: true,
                              onChanged: (val) => controller.choose(val),
                              onTap: () => controller.choose("instapay"),
                              typeUser: "instapay",
                              choose: controller.payment == "" || controller.payment == "instapay"),
                        ],
                      ),
                      ButtonWidget(
                          colorBorder: ThemeService.primaryColor,
                          colorFill: ThemeService.primaryColor,
                          colorText: LightMode.whiteColor,
                          margin: false,
                          onPress: () {
                            if (controller.payment != null && controller.payment != "") {
                              Get.to(() => const CheckOutPage(), arguments: {"totalCost": controller.totalCost, "payment": controller.payment});
                            } else if (controller.payment == "" || controller.payment == "instapay") {
                              Get.to(() => const CheckOutPage(), arguments: {"totalCost": controller.totalCost, "payment": "instapay"});
                            } else {
                              messageError("Warning", "Please Choose Payment Method.");
                            }
                          },
                          size: 3.5.w,
                          text: "Check Out",
                          width: 100.w),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}