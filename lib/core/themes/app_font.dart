import 'package:assignment/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Font sizes extension for quick access
  static TextStyle get s10 => const TextStyle(fontSize: 10);
  static TextStyle get s12 => const TextStyle(fontSize: 12);
  static TextStyle get s14 => const TextStyle(fontSize: 14);
  static TextStyle get s16 => const TextStyle(fontSize: 16);
  static TextStyle get s18 => const TextStyle(fontSize: 18);
  static TextStyle get s20 => const TextStyle(fontSize: 20);
  static TextStyle get s24 => const TextStyle(fontSize: 24);

  // Common text styles
  static TextStyle get title => TextStyle(
        fontSize: 20,
        fontWeight: bold,
        color: AppColor.textPrimary,
      );

  static TextStyle get subtitle => TextStyle(
        fontSize: 16,
        fontWeight: medium,
        color: AppColor.textPrimary,
      );

  static TextStyle get body => TextStyle(
        fontSize: 14,
        fontWeight: regular,
        color: AppColor.textPrimary,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 12,
        fontWeight: regular,
        color: AppColor.textSecondary,
      );

  static TextStyle get lightText => TextStyle(
        fontSize: 14,
        fontWeight: light,
        color: AppColor.textPrimary,
      );
}
