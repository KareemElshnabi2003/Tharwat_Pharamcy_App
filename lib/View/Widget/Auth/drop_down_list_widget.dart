import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';

class DropDownListWidget extends StatelessWidget {
  final String title;
  final String? value;
  final Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> itemes;
  final bool edit;

  const DropDownListWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.itemes,
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.w, bottom: 3.w),
      width: edit ? 80.w : 90.w,
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
          border: Border.all(color: LightMode.mainColor, width: 1.5),
          color: edit ? LightMode.whiteBlueColor : ThemeService.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(3.w))),
      child: Row(
        children: [
          SizedBox(
            width: 7.w,
            child: Icon(Icons.location_on_outlined, size: 7.w, color: LightMode.mainColor),
          ),
          SizedBox(
            width: edit ? 67.3.w : 79.w,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  padding: EdgeInsets.zero,
                  style: GoogleFonts.poppins(fontSize: 3.5.w, fontWeight: FontWeight.w600, color: LightMode.mainColor),
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  iconDisabledColor: LightMode.mainColor,
                  iconEnabledColor: LightMode.mainColor,
                  menuMaxHeight: 25.h,
                  hint: Text(
                    title,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(fontSize: 4.w, fontWeight: FontWeight.w600, color: LightMode.mainColor),
                  ),
                  dropdownColor: edit ? LightMode.whiteBlueColor : ThemeService.isDark ? LightMode.darkMainColor : LightMode.whiteColor,
                  value: value,
                  items: itemes,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownListGenderWidget extends StatelessWidget {
  final String title;
  final String? value;
  final List valueList;
  final Function(Object?)? onChange;
  final bool edit;

  const DropDownListGenderWidget({
    super.key,
    required this.title,
    required this.value,
    required this.valueList,
    required this.onChange,
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.w, bottom: 3.w),
      width: edit ? 80.w : 90.w,
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
          border: Border.all(color: LightMode.mainColor, width: 1.5),
          color: edit ? LightMode.whiteBlueColor : ThemeService.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(3.w))),
      child: Row(
        children: [
          SizedBox(
            width: 7.w,
            child: Icon(Icons.location_on_outlined, size: 7.w, color: LightMode.mainColor),
          ),
          SizedBox(
            width: edit ? 65.w : 79.w,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  padding: EdgeInsets.zero,
                  style: GoogleFonts.poppins(fontSize: 3.5.w, fontWeight: FontWeight.w600, color: LightMode.mainColor),
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  iconDisabledColor: LightMode.mainColor,
                  iconEnabledColor: LightMode.mainColor,
                  menuMaxHeight: 25.h,
                  hint: Text(
                    title,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(fontSize: 3.5.w, fontWeight: FontWeight.w600, color: LightMode.mainColor),
                  ),
                  value: value,
                  dropdownColor: edit ? LightMode.whiteBlueColor : ThemeService.isDark ? LightMode.darkMainColor : LightMode.whiteColor,
                  items: List.generate(
                    valueList.length,
                        (index) => DropdownMenuItem(
                        value: valueList[index],
                        child: Text(valueList[index], style: GoogleFonts.poppins(fontSize: 3.5.w, fontWeight: FontWeight.w600, color: LightMode.mainColor))),
                  ),
                  onChanged: onChange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}