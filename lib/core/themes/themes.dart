import 'package:application/core/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final appTheme = ThemeData(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.whiteColor,
    cardColor: AppColors.whiteColor,
    hoverColor: AppColors.transparentColor,
    dividerTheme: const DividerThemeData(
      color: AppColors.transparentColor,
    ),
    datePickerTheme:const DatePickerThemeData(
      backgroundColor: Colors.white,
      confirmButtonStyle: ButtonStyle(
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(
          Colors.black,
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(
          Colors.black,
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
