import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/core/constants/app_constants.dart';
import 'app_theme.dart';

class WhitelabelTheme {
  static ThemeData getTheme(String host) {
    final config = AppConstants.getConfigByHost(host);

    return AppTheme.getTheme(
      primaryColor: config?['primaryColor'],
      secondaryColor: config?['secondaryColor'],
    );
  }
}
