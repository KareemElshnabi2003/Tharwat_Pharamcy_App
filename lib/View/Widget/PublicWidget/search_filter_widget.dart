import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';

class SearchFilterWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChange;
  final VoidCallback? onPressFilter;
  final Color? colorFill;
  final Color? colorText;
  final Color? colorIconFilter;
  final Color? colorBorderIconFilter;
  final Color? colorIconSearch;

  const SearchFilterWidget({
    super.key,
    this.controller,
    this.onChange,
    this.onPressFilter,
    this.colorFill,
    this.colorText,
    this.colorIconFilter,
    this.colorBorderIconFilter,
    this.colorIconSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 74.w,
          height: 5.h,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: colorFill,
              filled: true,
              hintText: "Search",
              hintStyle: GoogleFonts.poppins(color: colorText, fontSize: 3.5.w, fontWeight: FontWeight.w400),
              prefixIcon: Icon(Icons.search, color: colorIconSearch, size: 5.w),
              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(3.w)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(3.w)),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(3.w)),
            ),
            onChanged: onChange,
            style: GoogleFonts.poppins(color: colorText, fontSize: 3.5.w, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(width: 2.w),
        InkWell(
          onTap: onPressFilter,
          child: Container(
            height: 5.h,
            width: 10.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              color: ThemeService.isDark ? ThemeService.primaryColor : colorBorderIconFilter,
            ),
            child: Icon(Icons.settings, color: colorIconFilter, size: 5.w),
          ),
        ),
      ],
    );
  }
}