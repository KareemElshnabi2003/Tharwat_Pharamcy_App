import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class OrderItemsTableWidget extends StatelessWidget {
  final List items; // مرر هنا قائمة المنتجات الموجودة داخل الطلب

  const OrderItemsTableWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: LightMode.mainColor, thickness: 1.5),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2.5),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(0.8),
            3: FlexColumnWidth(1.5),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            verticalInside: BorderSide(color: LightMode.mainColor, width: 1.5),
          ),
          children: [
            // 1. صف العناوين (Header)
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 2.w),
                  child: TextNormalWidget(
                      text: "Description",
                      color: LightMode.mainColor,
                      size: 3.5.w,
                      weight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                  child: TextNormalWidget(
                      text: "Price",
                      color: LightMode.mainColor,
                      size: 3.5.w,
                      weight: FontWeight.bold,
                      center: true),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                  child: TextNormalWidget(
                      text: "Qty",
                      color: LightMode.mainColor,
                      size: 3.5.w,
                      weight: FontWeight.bold,
                      center: true),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                  child: TextNormalWidget(
                      text: "Total",
                      color: LightMode.mainColor,
                      size: 3.5.w,
                      weight: FontWeight.bold,
                      center: true),
                ),
              ],
            ),
            // 2. صفوف المنتجات (Items)
            ...items.map((item) => TableRow(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
                      child: TextNormalWidget(
                        // ملاحظة: قم بتعديل ".productName" حسب اسم المتغير في الـ Model الخاص بك
                        text: item.productName ?? "Product Name",
                        color: ThemeService.isDark
                            ? LightMode.whiteBlueColor
                            : LightMode.greyColor,
                        size: 3.w,
                        weight: FontWeight.w500,
                        multi: true,
                        numOfRow: 2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                      child: TextNormalWidget(
                        text: "${item.price ?? 25} EGP", // عدل ".price"
                        color: ThemeService.isDark
                            ? LightMode.whiteBlueColor
                            : LightMode.greyColor,
                        size: 3.w,
                        weight: FontWeight.w500,
                        center: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                      child: TextNormalWidget(
                        text: "0${item.quantity ?? 1}", // عدل ".quantity"
                        color: ThemeService.isDark
                            ? LightMode.whiteBlueColor
                            : LightMode.greyColor,
                        size: 3.w,
                        weight: FontWeight.w500,
                        center: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                      child: TextNormalWidget(
                        text:
                            "${(item.price ?? 25) * (item.quantity ?? 1)} EGP", // المجموع
                        color: ThemeService.textColor,
                        size: 3.w,
                        weight: FontWeight.bold,
                        center: true,
                      ),
                    ),
                  ],
                )),
          ],
        ),
        const Divider(color: LightMode.mainColor, thickness: 1.5),
      ],
    );
  }
}
