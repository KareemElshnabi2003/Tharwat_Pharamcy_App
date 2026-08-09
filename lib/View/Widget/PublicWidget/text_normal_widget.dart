import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';

class TextNormalWidget extends StatelessWidget {
  final String? text;
  final Color color;
  final double size;
  final FontWeight weight;
  final bool center;
  final bool multi;
  final int numOfRow;
  final bool bgcolor;

  const TextNormalWidget({
    super.key,
    required this.text,
    required this.color,
    required this.size,
    required this.weight,
    this.center = false,
    this.multi = false,
    this.numOfRow = 2,
    this.bgcolor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      overflow: TextOverflow.ellipsis,
      textAlign: center ? TextAlign.center : null,
      maxLines: multi ? numOfRow : 2,
      style: GoogleFonts.poppins(
        backgroundColor: bgcolor ? LightMode.whiteColor.withOpacity(.5) : null,
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}