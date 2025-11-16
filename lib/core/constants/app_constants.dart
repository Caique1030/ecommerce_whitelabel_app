class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String apiVersion = 'v1';

  // WebSocket Configuration
  static const String wsNamespace = 'events';

  // Endpoints
  static const String authEndpoint = '/auth';
  static const String productsEndpoint = '/products';
  static const String clientsEndpoint = '/clients';
  static const String suppliersEndpoint = '/suppliers';
  static const String usersEndpoint = '/users';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String userDataKey = 'user_data';
  static const String clientConfigKey = 'client_config';

  // Default Values
  static const int defaultPageSize = 20;
  static const int requestTimeout = 30;

  // Client Domains
  static const Map<String, String> clientDomains = {
    'localhost': 'localhost',
    'devnology': 'devnology.com',
    'in8': 'in8.com',
  };

  // Theme Colors
  static const Map<String, Map<String, String>> clientColors = {
    'localhost': {'primary': '#2ecc71', 'secondary': '#27ae60'},
    'devnology': {'primary': '#2ecc71', 'secondary': '#27ae60'},
    'in8': {'primary': '#8e44ad', 'secondary': '#9b59b6'},
  };
}
