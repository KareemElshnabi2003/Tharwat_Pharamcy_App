import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/type_user_choose.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

void bottomSheetChangeLang({
  VoidCallback? onPressAr,
  ValueChanged<Object?>? onPressArChang,
  ValueChanged<Object?>? onPressEnChang,
  VoidCallback? onPressEn,
  required BuildContext context,
  required Object groubVAl,
}) {
  showModalBottomSheet(
    backgroundColor: LightMode.whiteColor,
    context: context,
    builder: (context) => Container(
      height: 22.h,
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child:
                    Icon(Icons.close, color: LightMode.blackColor, size: 5.w),
              ),
              TextNormalWidget(
                  text: "اللغة",
                  color: LightMode.blackColor,
                  size: 4.5.w,
                  weight: FontWeight.w700),
              const SizedBox()
            ],
          ),
          const SizedBox(height: 20),
          TypeUserChooseWidget(
              lang: true,
              groubVal: groubVAl,
              onChanged: onPressArChang,
              onTap: onPressAr,
              payment: false,
              typeUser: "العربية"),
          TypeUserChooseWidget(
              lang: true,
              groubVal: groubVAl,
              onChanged: onPressEnChang,
              onTap: onPressEn,
              payment: false,
              typeUser: "English"),
        ],
      ),
    ),
  );
}
