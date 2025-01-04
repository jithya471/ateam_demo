import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle style(
  double fontSize,
  FontWeight weight,
  Color color, [
  double? tHeight,
  TextDecoration? underline,
  TextOverflow? overflow,
  FontStyle? fontStyle, // Add this parameter
]) {
  return TextStyle(
    fontFamily: GoogleFonts.roboto(fontWeight: weight).fontFamily,
    fontSize: fontSize,
    fontWeight: weight,
    color: color,
    height: tHeight ?? 1.5,
    overflow: overflow ?? TextOverflow.ellipsis,
    decoration: underline ?? TextDecoration.none,
    fontStyle: fontStyle ?? FontStyle.normal, // Add this line
  );
}
