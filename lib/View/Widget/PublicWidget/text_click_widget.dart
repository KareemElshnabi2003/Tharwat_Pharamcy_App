import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextClickWidget extends StatelessWidget {
  final String text;
  final bool decoration;
  final VoidCallback onPress;
  final Color color;
  final double size;

  const TextClickWidget({
    super.key,
    required this.text,
    required this.decoration,
    required this.onPress,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Text(
        text,
        style: GoogleFonts.poppins(
            decoration: decoration ? TextDecoration.underline : null,
            decorationColor: color,
            color: color,
            fontSize: size,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
