import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';

class AppBarProductInfoWidget extends StatelessWidget {
  final VoidCallback onPressBack;
  final VoidCallback onPressFav;
  final bool fav;

  const AppBarProductInfoWidget({
    super.key,
    required this.onPressBack,
    required this.onPressFav,
    required this.fav,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 7.w, left: 7.w, top: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onPressBack,
            child: CircleAvatar(
              backgroundColor: LightMode.whiteColor,
              radius: 5.w,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: LightMode.blackColor,
                size: 6.w,
              ),
            ),
          ),
          InkWell(
            onTap: onPressFav,
            child: CircleAvatar(
              backgroundColor: LightMode.whiteColor,
              radius: 5.w,
              child: Icon(
                fav ? Icons.favorite : Icons.favorite_outline_rounded,
                color: fav ? LightMode.redColor : LightMode.blackColor,
                size: 6.w,
              ),
            ),
          )
        ],
      ),
    );
  }
}
