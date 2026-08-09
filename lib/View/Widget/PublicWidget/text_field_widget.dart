import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool iconic;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType? keyBoard;
  final VoidCallback? onPress;
  final IconData icon;
  final bool lines;
  final VoidCallback? onTap;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.iconic = false,
    this.obscure = false,
    this.validator,
    this.keyBoard,
    this.onPress,
    required this.icon,
    this.lines = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TextFormField(
        controller: controller,
        keyboardType: keyBoard,
        obscureText: obscure,
        validator: validator,
        maxLines: lines ? 11 : 1,
        maxLength: lines ? 500 : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: GoogleFonts.poppins(
            color: LightMode.mainColor,
            fontSize: 4.w,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            size: 6.w,
            color: LightMode.mainColor,
          ),
          suffixIcon: iconic
              ? InkWell(
            onTap: onPress,
            child: Icon(
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: LightMode.mainColor,
              size: 6.w,
            ),
          )
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: LightMode.mainColor, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: LightMode.mainColor, width: 1.5)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: LightMode.mainColor, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: LightMode.mainColor, width: 1.5)),
          contentPadding: EdgeInsets.all(4.w),
          errorStyle: GoogleFonts.poppins(
              color: LightMode.redColor, fontSize: 4.w, fontWeight: FontWeight.w500),
          hintStyle: GoogleFonts.poppins(
              color: LightMode.mainColor, fontSize: 4.w, fontWeight: FontWeight.w500),
          hintText: hintText,
        ),
      ),
    );
  }
}