import 'dart:ui';

class AppConstants {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String apiVersion = 'v1';

  static const String authEndpoint = '/auth';
  static const String productsEndpoint = '/products';
  static const String clientsEndpoint = '/clients';
  static const String suppliersEndpoint = '/suppliers';
  static const String usersEndpoint = '/users';
  static const String ordersEndpoint = '/orders';

  static const String accessTokenKey = 'access_token';
  static const String userDataKey = 'user_data';
  static const String clientConfigKey = 'client_config';

  static const int defaultPageSize = 20;
  static const int requestTimeout = 30;

  static const Map<String, String> clientDomains = {
    'localhost': 'localhost',
    'devnology': 'devnology.com',
    'in8': 'in8.com',
  };

  static const Map<String, Map<String, String>> clientColors = {
    'localhost': {'primary': '#2ecc71', 'secondary': '#27ae60'},
    'devnology.com': {'primary': '#2ecc71', 'secondary': '#27ae60'},
    'in8.com': {'primary': '#8e44ad', 'secondary': '#9b59b6'},
  };

  static Map<String, dynamic>? getConfigByHost(String host) {

    final cleanHost = host.split(':')[0].trim();

    String domainKey;

    if (cleanHost.contains('devnology.com') || cleanHost == 'devnology.com') {
      domainKey = 'devnology.com';
    } else if (cleanHost.contains('in8.com') || cleanHost == 'in8.com') {
      domainKey = 'in8.com';
    } else if (cleanHost == 'localhost' || cleanHost == '127.0.0.1') {
      domainKey = 'localhost';
    } else {
      domainKey = 'localhost';
    }


    final colors = clientColors[domainKey];

    if (colors == null) {
      return null;
    }


    final config = {
      'primaryColor': _hexToColor(colors['primary']!),
      'secondaryColor': _hexToColor(colors['secondary']!),
      'domainKey': domainKey,
      'host': cleanHost,
    };


    return config;
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  static String getCleanDomain(String host) {
    return host.split(':')[0].trim();
  }

  static bool isDevnology(String host) {
    final cleanHost = getCleanDomain(host);
    return cleanHost == 'devnology.com' || cleanHost.contains('devnology');
  }

  static bool isIn8(String host) {
    final cleanHost = getCleanDomain(host);
    return cleanHost == 'in8.com' || cleanHost.contains('in8');
  }

  static bool isLocalhost(String host) {
    final cleanHost = getCleanDomain(host);
    return cleanHost == 'localhost' || cleanHost == '127.0.0.1';
  }
}
