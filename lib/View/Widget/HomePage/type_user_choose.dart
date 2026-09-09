import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class TypeUserChooseWidget extends StatelessWidget {
  final bool lang;
  final VoidCallback? onTap;
  final ValueChanged<Object?>? onChanged;
  final String typeUser;
  final Object? groubVal;
  final bool payment;
  final Widget? img;
  final bool choose;

  const TypeUserChooseWidget({
    super.key,
    this.lang = false,
    this.onTap,
    this.onChanged,
    required this.typeUser,
    this.groubVal,
    this.payment = false,
    this.img,
    this.choose = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: lang ? null : EdgeInsets.only(bottom: 4.w),
        padding: lang
            ? null
            : EdgeInsets.only(right: 3.w, left: 3.w, top: 4.w, bottom: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: lang
              ? null
              : Border.all(
                  color: choose
                      ? LightMode.mainColor
                      : ThemeService.isDark
                          ? LightMode.whiteBlueColor
                          : LightMode.greyColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (payment && img != null) img!,
                if (payment) const SizedBox(width: 10),
                TextNormalWidget(
                    text: typeUser,
                    color: choose
                        ? LightMode.mainColor
                        : ThemeService.isDark
                            ? LightMode.greyColor
                            : LightMode.blackColor.withValues(alpha: .5),
                    size: 4.w,
                    weight: FontWeight.w600),
              ],
            ),
            Radio(
                focusColor: ThemeService.isDark
                    ? LightMode.whiteBlueColor
                    : LightMode.mainColor,
                activeColor: LightMode.mainColor,
                value: typeUser,
                groupValue: groubVal,
                onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
