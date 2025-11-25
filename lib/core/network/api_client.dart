import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final http.Client httpClient;
  final SharedPreferences sharedPreferences;

  ApiClient({required this.httpClient, required this.sharedPreferences});

  String get _baseUrl => AppConstants.baseUrl;

  Future<String?> get _token async {
    return sharedPreferences.getString(AppConstants.accessTokenKey);
  }

  /// Obtém o domínio atual de forma consistente
  String get _domain {
    try {
      final host = Uri.base.host;
      print('🌐 ApiClient - Domínio detectado (Uri.base.host): $host');

      // Limpa o host removendo porta se existir
      final cleanHost = AppConstants.getCleanDomain(host);
      print('🧹 ApiClient - Host limpo: $cleanHost');

      // Usa a mesma lógica do AppConstants
      if (AppConstants.isDevnology(cleanHost)) {
        print('✅ ApiClient - Cliente identificado: devnology.com');
        return 'devnology.com';
      } else if (AppConstants.isIn8(cleanHost)) {
        print('✅ ApiClient - Cliente identificado: in8.com');
        return 'in8.com';
      } else if (AppConstants.isLocalhost(cleanHost)) {
        print('✅ ApiClient - Cliente identificado: localhost');
        return 'localhost';
      }

      print('⚠️ ApiClient - Domínio não reconhecido, usando localhost');
      return 'localhost';
    } catch (e) {
      print('❌ Erro ao detectar domínio: $e');
      return 'localhost';
    }
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Client-Domain': _domain,
    };

    if (includeAuth) {
      final token = await _token;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        print('🔑 Token adicionado ao header: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ AVISO: Requisição autenticada mas token não encontrado!');
      }
    }

    print('📨 Headers enviados: $headers');
    return headers;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);

      print('🌐 GET Request: $uri');

      final headers = await _getHeaders(includeAuth: requiresAuth);

      final response = await httpClient
          .get(uri, headers: headers)
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      print('🌐 POST Request: $uri');
      print('📦 Body: $body');

      final headers = await _getHeaders(includeAuth: requiresAuth);

      final response = await httpClient
          .post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      print('🌐 PATCH Request: $uri');
      print('📦 Body: $body');

      final headers = await _getHeaders(includeAuth: requiresAuth);

      final response = await httpClient
          .patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      print('🌐 DELETE Request: $uri');

      final headers = await _getHeaders(includeAuth: requiresAuth);

      final response = await httpClient
          .delete(uri, headers: headers)
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    print('📥 Response Status: $statusCode');

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return json.decode(response.body);
    } else if (statusCode == 401) {
      throw AuthenticationException(
        message: 'Authentication failed. Please login again.',
      );
    } else if (statusCode == 404) {
      throw NotFoundException(message: 'Resource not found');
    } else if (statusCode >= 400 && statusCode < 500) {
      final errorBody = json.decode(response.body);
      throw ValidationException(
        message: errorBody['message'] ?? 'Validation error',
        errors: errorBody['errors'],
      );
    } else if (statusCode >= 500) {
      throw ServerException(
        message: 'Server error occurred',
        statusCode: statusCode,
      );
    } else {
      throw ServerException(
        message: 'Unexpected error occurred',
        statusCode: statusCode,
      );
    }
  }

  Exception _handleError(dynamic error) {
    print('❌ Erro na requisição: $error');
    if (error is Exception) {
      return error;
    } else {
      return NetworkException(message: 'Network error: ${error.toString()}');
    }
  }
}
