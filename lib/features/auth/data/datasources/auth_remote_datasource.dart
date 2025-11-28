import 'dart:convert';
import 'package:flutter_ecommerce/features/users/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.sharedPreferences,
  });

  // ...existing code...
  @override
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '${AppConstants.authEndpoint}/login',
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      print('📦 Resposta do login: $response'); // 🔍 LOG

      // Salvar token
      final token = response['access_token'] as String?;
      if (token != null) {
        await sharedPreferences.setString(AppConstants.accessTokenKey, token);
        print(
            '✅ Token salvo: ${token.substring(0, 20)}...'); // 🔍 LOG (mostra só início)

        // Verificar se foi salvo mesmo
        final savedToken =
            sharedPreferences.getString(AppConstants.accessTokenKey);
        print(
            '🔍 Token recuperado do storage: ${savedToken?.substring(0, 20)}...'); // 🔍 LOG
      } else {
        print('❌ ERRO: Token não encontrado na resposta!'); // 🔍 LOG
      }

      // Salvar dados do usuário
      final userData = response['user'];
      if (userData != null) {
        await sharedPreferences.setString(
          AppConstants.userDataKey,
          json.encode(userData),
        );
        print('✅ Dados do usuário salvos: ${userData['email']}'); // 🔍 LOG
      }

      return response;
    } catch (e) {
      print('❌ Erro no signIn: $e'); // 🔍 LOG
      if (e is AuthenticationException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to sign in: ${e.toString()}');
    }
  }
// ...existing code...

  @override
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await apiClient.post(
        '${AppConstants.authEndpoint}/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
        requiresAuth: false,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      // Salvar token se vier
      final token = response['access_token'] as String?;
      if (token != null) {
        await sharedPreferences.setString(AppConstants.accessTokenKey, token);
      }

      // Salvar dados do usuário
      final userData = response['user'];
      if (userData != null) {
        await sharedPreferences.setString(
          AppConstants.userDataKey,
          json.encode(userData),
        );
      }

      return response;
    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await sharedPreferences.remove(AppConstants.accessTokenKey);
      await sharedPreferences.remove(AppConstants.userDataKey);
    } catch (e) {
      throw CacheException(message: 'Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userDataString = sharedPreferences.getString(
        AppConstants.userDataKey,
      );

      if (userDataString == null) {
        return null;
      }

      final userData = json.decode(userDataString);
      return UserModel.fromJson(userData);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get current user: ${e.toString()}',
      );
    }
  }
}
