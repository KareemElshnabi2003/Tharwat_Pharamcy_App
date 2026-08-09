import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Data/Model/User/city_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/country_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/district_model.dart';

void showDialogGovernate({
  required String title,
  required int count,
  required Future<dynamic> getNextLocation,
  List<CountryModel>? valueCountry,
  List<CityModel>? valueCity,
  List<DistrictModel>? valueDistrict,
  required String type,
  required Function(String id, String name) onSelect,
}) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 80.w,
        height: 50.h,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 5.w),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2.w), topRight: Radius.circular(2.w)),
                color: LightMode.whiteColor,
              ),
              width: 80.w,
              height: 8.h,
              child: Text(
                title,
                style: GoogleFonts.poppins(fontSize: 5.w, color: LightMode.mainColor, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 80.w,
              height: 42.h,
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      String selectedId = valueCountry![index].id.toString();
                      String selectedName = valueCountry[index].name!;

                      onSelect(selectedId, selectedName); // إرجاع القيمة للكنترولر
                      await getNextLocation;

                      Get.back();
                      Get.appUpdate();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 3.w, right: 5.w, left: 5.w),
                      height: 6.h,
                      width: 80.w,
                      child: Text(
                        type == "city" ? valueCity![index].name! : type == "country" ? valueCountry![index].name! : valueDistrict![index].name!,
                        style: GoogleFonts.tajawal(fontSize: 4.w, color: LightMode.mainColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: count),
            ),
          ],
        ),
      ),
    ),
  );
}