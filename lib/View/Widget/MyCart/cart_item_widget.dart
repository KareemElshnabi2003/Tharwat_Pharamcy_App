import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class ItemCartWidget extends StatelessWidget {
  final ImageProvider decorationImage;
  final String name;
  final String body;
  final String price;
  final int numOfItems;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ItemCartWidget({
    super.key,
    required this.decorationImage,
    required this.name,
    required this.body,
    required this.price,
    required this.numOfItems,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: LightMode.mainColor, width: 1.5),
        borderRadius: BorderRadius.circular(2.w),
      ),
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.w, bottom: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 15.w,
                width: 15.w,
                decoration: BoxDecoration(
                    image: DecorationImage(image: decorationImage, fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(2.w)),
              ),
              SizedBox(width: 2.w),
              SizedBox(
                width: 43.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextNormalWidget(
                        text: name, color: LightMode.mainColor, size: 3.w, weight: FontWeight.w700, multi: true, numOfRow: 2),
                    const SizedBox(height: 10),
                    TextNormalWidget(
                        text: body, color: LightMode.greyColor, size: 2.5.w, weight: FontWeight.w700, multi: true, numOfRow: 2),
                    const SizedBox(height: 10),
                    TextNormalWidget(
                        text: "\$ $price", color: LightMode.mainColor, size: 3.w, weight: FontWeight.w700),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      border: Border.all(color: LightMode.mainColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: onRemove,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1.w, left: 1.w),
                            child: Icon(
                              Icons.remove,
                              color: ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.mainColor,
                              size: 5.w,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 2.w, left: 2.w),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: LightMode.mainColor, width: 1.5),
                              right: BorderSide(color: LightMode.mainColor, width: 1.5),
                            ),
                          ),
                          child: TextNormalWidget(
                              text: "$numOfItems",
                              color: ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.mainColor,
                              size: 3.5.w,
                              weight: FontWeight.w700),
                        ),
                        InkWell(
                          onTap: onAdd,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1.w, left: 1.w),
                            child: Icon(
                              Icons.add,
                              color: ThemeService.isDark ? LightMode.whiteBlueColor : LightMode.mainColor,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}