import 'package:application/core/themes/colors.dart';
import 'package:flutter/material.dart';


class AppTheme{
  static final appTheme = ThemeData(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.whiteColor,
    cardColor: AppColors.whiteColor,
    hoverColor: AppColors.transparentColor,
  );
}