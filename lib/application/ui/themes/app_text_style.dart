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
}
