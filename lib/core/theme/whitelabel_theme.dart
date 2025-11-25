import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/core/constants/app_constants.dart';
import 'app_theme.dart';

class WhitelabelTheme {
  /// Obtém o tema baseado no host
  ///
  /// Exemplos de hosts válidos:
  /// - 'localhost' ou 'localhost:8080' -> Verde
  /// - 'devnology.com' ou 'devnology.com:8080' -> Verde
  /// - 'in8.com' ou 'in8.com:8080' -> Roxo
  static ThemeData getTheme(String host) {
    print('🎨 WhitelabelTheme.getTheme - Host recebido: $host');

    final config = AppConstants.getConfigByHost(host);

    if (config == null) {
      print('⚠️ Config null, usando tema padrão (azul)');
      return AppTheme.getTheme();
    }

    print(
        '✅ Aplicando tema com cores: primary=${config['primaryColor']}, secondary=${config['secondaryColor']}');

    return AppTheme.getTheme(
      primaryColor: config['primaryColor'],
      secondaryColor: config['secondaryColor'],
    );
  }

  /// Obtém apenas a cor primária baseada no host
  static Color getPrimaryColor(String host) {
    final config = AppConstants.getConfigByHost(host);
    return config?['primaryColor'] ?? Colors.blue;
  }

  /// Obtém apenas a cor secundária baseada no host
  static Color getSecondaryColor(String host) {
    final config = AppConstants.getConfigByHost(host);
    return config?['secondaryColor'] ?? Colors.blueAccent;
  }
}
