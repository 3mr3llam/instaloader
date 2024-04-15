import 'package:flutter/material.dart';
import 'package:instaloader/utils/constants.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: bgColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
    background: bgColor,
  ),
);
