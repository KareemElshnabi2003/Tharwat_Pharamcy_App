import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class ProductWidget extends StatelessWidget {
  final VoidCallback onPressFav;
  final bool fav;
  final ImageProvider decorationImage;
  final String title;
  final double? rate;
  final String body;
  final String price;
  final VoidCallback onPressShop;

  const ProductWidget({
    super.key,
    required this.onPressFav,
    required this.fav,
    required this.decorationImage,
    required this.title,
    this.rate,
    required this.body,
    required this.price,
    required this.onPressShop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      decoration: BoxDecoration(
        color: ThemeService.isDark
            ? LightMode.darkMainColor
            : LightMode.whiteColor,
        border: Border.all(color: LightMode.mainColor, width: 2),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Stack(
        children: [
          Container(
            height: 17.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.w),
                    bottomRight: Radius.circular(7.w),
                    topRight: Radius.circular(5.w)),
                image:
                    DecorationImage(image: decorationImage, fit: BoxFit.cover)),
          ),
          Positioned(
            top: 14.h,
            bottom: 0,
            left: 0,
            child: InkWell(
              onTap: onPressShop,
              child: Container(
                  padding: EdgeInsets.only(
                      right: 3.w, left: 3.w, top: 3.w, bottom: 1.w),
                  width: 42.w,
                  decoration: BoxDecoration(
                    color: ThemeService.backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.w),
                      bottomRight: Radius.circular(6.5.w),
                      topLeft: Radius.circular(5.w),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 36.w,
                            child: TextNormalWidget(
                                text: title,
                                color: ThemeService.textColor,
                                multi: true,
                                numOfRow: 2,
                                size: 3.w,
                                weight: FontWeight.w800),
                          ),
                        ],
                      ),
                      TextNormalWidget(
                          text: body,
                          color: ThemeService.secondaryTextColor,
                          size: 3.w,
                          weight: FontWeight.w500),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextNormalWidget(
                              text: "\$ $price",
                              color: LightMode.mainColor,
                              size: 3.w,
                              weight: FontWeight.w700),
                          InkWell(
                            onTap: onPressShop,
                            child: CircleAvatar(
                              backgroundColor: LightMode.orangeColor,
                              radius: 4.w,
                              child: Icon(
                                Icons.shopping_cart,
                                color: LightMode.whiteColor,
                                size: 4.w,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          ),
          Positioned(
              right: 4.w,
              top: 4.w,
              child: InkWell(
                onTap: onPressFav,
                child: CircleAvatar(
                  backgroundColor: LightMode.whiteColor,
                  child: Icon(
                    fav ? Icons.favorite : Icons.favorite_border,
                    size: 6.w,
                    color: fav ? LightMode.redColor : LightMode.blackColor,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
