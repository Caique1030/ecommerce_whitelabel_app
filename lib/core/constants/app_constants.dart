import 'dart:ui';

class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String apiVersion = 'v1';

  // Endpoints
  static const String authEndpoint = '/auth';
  static const String productsEndpoint = '/products';
  static const String clientsEndpoint = '/clients';
  static const String suppliersEndpoint = '/suppliers';
  static const String usersEndpoint = '/users';
  static const String ordersEndpoint = '/orders';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String userDataKey = 'user_data';
  static const String clientConfigKey = 'client_config';

  // Default Values
  static const int defaultPageSize = 20;
  static const int requestTimeout = 30;

  // Client Domains - CORRIGIDO
  static const Map<String, String> clientDomains = {
    'localhost': 'localhost',
    'devnology': 'devnology.com',
    'in8': 'in8.com',
  };

  // Theme Colors - CORRIGIDO
  static const Map<String, Map<String, String>> clientColors = {
    'localhost': {'primary': '#2ecc71', 'secondary': '#27ae60'},
    'devnology.com': {'primary': '#2ecc71', 'secondary': '#27ae60'}, // ✅ VERDE
    'in8.com': {'primary': '#8e44ad', 'secondary': '#9b59b6'}, // ✅ ROXO
  };

  /// Obtém a configuração de cores baseada no host
  /// Exemplos de host: 'localhost', 'devnology.com', 'in8.com', 'localhost:8080'
  static Map<String, dynamic>? getConfigByHost(String host) {
    print('🔍 getConfigByHost - Host recebido: $host');

    // Remove porta se existir (localhost:8080 -> localhost)
    final cleanHost = host.split(':')[0].trim();
    print('🧹 Host limpo (sem porta): $cleanHost');

    // Determina qual cliente baseado no host
    String domainKey;

    if (cleanHost.contains('devnology.com') || cleanHost == 'devnology.com') {
      domainKey = 'devnology.com';
    } else if (cleanHost.contains('in8.com') || cleanHost == 'in8.com') {
      domainKey = 'in8.com';
    } else if (cleanHost == 'localhost' || cleanHost == '127.0.0.1') {
      domainKey = 'localhost';
    } else {
      print('⚠️ Domínio não reconhecido, usando localhost como fallback');
      domainKey = 'localhost';
    }

    print('🎯 Domain Key selecionado: $domainKey');

    final colors = clientColors[domainKey];

    if (colors == null) {
      print('❌ Cores não encontradas para: $domainKey');
      return null;
    }

    print('🎨 Cores encontradas: $colors');

    final config = {
      'primaryColor': _hexToColor(colors['primary']!),
      'secondaryColor': _hexToColor(colors['secondary']!),
      'domainKey': domainKey,
      'host': cleanHost,
    };

    print(
        '✅ Config gerada: primaryColor=${colors['primary']}, secondaryColor=${colors['secondary']}');

    return config;
  }

  /// Converte string hexadecimal para Color
  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  /// Obtém o domínio limpo do host (sem porta)
  static String getCleanDomain(String host) {
    return host.split(':')[0].trim();
  }

  /// Verifica se um host corresponde ao cliente devnology
  static bool isDevnology(String host) {
    final cleanHost = getCleanDomain(host);
    return cleanHost == 'devnology.com' || cleanHost.contains('devnology');
  }

  /// Verifica se um host corresponde ao cliente in8
  static bool isIn8(String host) {
    final cleanHost = getCleanDomain(host);
    return cleanHost == 'in8.com' || cleanHost.contains('in8');
  }

  /// Verifica se um host é localhost
  static bool isLocalhost(String host) {
    final cleanHost = getCleanDomain(host);
    return cleanHost == 'localhost' || cleanHost == '127.0.0.1';
  }
}
