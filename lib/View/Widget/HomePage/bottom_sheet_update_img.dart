import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

void bottomSheetUpdateImage(
    {VoidCallback? onPressGellery,
    VoidCallback? onPressCamera,
    VoidCallback? onPressDelete,
    required BuildContext context}) {
  showModalBottomSheet(
    backgroundColor: LightMode.whiteColor,
    context: context,
    builder: (context) => Container(
      height: 23.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  text: "Personal Image",
                  color: LightMode.blackColor,
                  size: 4.5.w,
                  weight: FontWeight.w700),
              const SizedBox()
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconOption(Icons.delete, "Delete", onPressDelete),
              _buildIconOption(Icons.photo, "Gallery", onPressGellery),
              _buildIconOption(Icons.camera_alt, "Camera", onPressCamera),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildIconOption(IconData icon, String text, VoidCallback? onTap) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LightMode.mainColor)),
          child: Icon(icon, color: LightMode.mainColor, size: 6.w),
        ),
        const SizedBox(height: 10),
        TextNormalWidget(
            text: text,
            color: LightMode.blackColor,
            size: 4.w,
            weight: FontWeight.w700),
      ],
    ),
  );
}
