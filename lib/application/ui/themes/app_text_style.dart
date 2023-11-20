import 'package:flutter/material.dart';
import 'package:senly/application/ui/themes/app_colors.dart';

class AppTextStyle {
  static TextStyle mainTextStyle(BuildContext context) {
    return const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w900,
      height: 22 / 19,
      color: AppColors.main,
    );
  }

  static TextStyle textStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w900,
      height: 22 / 19,
      color: color,
    );
  }

  static TextStyle nameTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w900,
      height: 22 / 21,
      color: color ?? AppColors.main,
      wordSpacing: -0.95,
    );
  }

  static TextStyle uploadTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w900,
      height: 16 / 11,
      color: color ?? AppColors.color2,
      wordSpacing: -0.95,
    );
  }

  static TextStyle logoutTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 18 / 16,
      color: color ?? AppColors.color2,
      wordSpacing: -0.95,
    );
  }

  static TextStyle messagesTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      height: 26 / 24,
      color: color ?? AppColors.main,
      wordSpacing: -0.95,
    );
  }
}
