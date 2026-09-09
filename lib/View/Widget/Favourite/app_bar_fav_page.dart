import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_app_widget.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart'; // قم بتفعيله إذا ألغيت التعليقات

class AppBarFavWidget extends StatelessWidget {
  final VoidCallback? onPressBack;
  final VoidCallback? onPressNotify;
  final VoidCallback? onPressCat_1;
  final VoidCallback? onPressCat_2;
  final bool choose_1;
  final bool choose_2;

  const AppBarFavWidget({
    super.key,
    this.onPressBack,
    this.onPressNotify,
    this.onPressCat_1,
    this.onPressCat_2,
    this.choose_1 = false,
    this.choose_2 = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: ThemeService.isDark
                  ? LightMode.darkMainColor
                  : LightMode.whiteColor,
              spreadRadius: 2,
              blurStyle: BlurStyle.solid,
              blurRadius: 3,
              offset: const Offset(0, 3)),
        ],
        color: ThemeService.isDark ? LightMode.nightColor : LightMode.mainColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5.w),
            bottomRight: Radius.circular(5.w)),
      ),
      child: Column(
        children: [
          AppBarWidget(
              // تم استخدام الكلاس الجديد هنا
              title: "Favourite",
              colorWhite: true,
              onPressBack: onPressBack,
              onPressNotify: onPressNotify),
          const SizedBox(
            height: 40,
          )
          // Padding(
          //   padding: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 3.w, top: 5.h),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       InkWell(
          //         onTap: onPressCat_1,
          //         child: Column(
          //           children: [
          //             TextNormalWidget(
          //                 text: "Medcine",
          //                 color: choose_1 == true
          //                     ? LightMode.whiteColor
          //                     : LightMode.greyColor,
          //                 size: 4.w,
          //                 weight: FontWeight.w600),
          //             if (choose_1)
          //               Container(
          //                 height: 1.w,
          //                 width: 30.w,
          //                 decoration: BoxDecoration(
          //                   color: LightMode.whiteColor,
          //                   borderRadius: BorderRadius.circular(2.w),
          //                 ),
          //               ),
          //           ],
          //         ),
          //       ),
          //       InkWell(
          //         onTap: onPressCat_2,
          //         child: Column(
          //           children: [
          //             TextNormalWidget(
          //                 text: "Cosmetics",
          //                 color: choose_2 == true
          //                     ? LightMode.whiteColor
          //                     : LightMode.greyColor,
          //                 size: 4.w,
          //                 weight: FontWeight.w600),
          //             if (choose_2)
          //               Container(
          //                 height: 1.w,
          //                 width: 30.w,
          //                 decoration: BoxDecoration(
          //                   color: LightMode.whiteColor,
          //                   borderRadius: BorderRadius.circular(2.w),
          //                 ),
          //               ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
