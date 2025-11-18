import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/app_constants.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<UserModel> getProfile();
  Future<UserModel> updateUser(String id, UserModel user);
  Future<UserModel> updateProfile(UserModel user);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteUser(String id);
  Future<List<UserModel>> getAllUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  UserRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  String get baseUrl => AppConstants.baseUrl;

  Map<String, String> get headers {
    final token = sharedPreferences.getString(AppConstants.accessTokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<UserModel> getUser(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      throw NotFoundException(message: 'User not found');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(message: 'Unauthorized');
    } else {
      throw ServerException(
          message: 'Erro no servidor',
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Unauthorized');
    } else {
      throw ServerException('Erro no servidor',
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> updateUser(String id, UserModel user) async {
    final body = json.encode(user.toJson());
    final response = await client.patch(
      Uri.parse('$baseUrl/users/$id'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap);
    } else if (response.statusCode == 400) {
      throw ValidationException('Dados inválidos');
    } else if (response.statusCode == 404) {
      throw NotFoundException('User not found');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Unauthorized');
    } else {
      throw ServerException('Erro no servidor',
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    final body = json.encode(user.toJson());
    final response = await client.patch(
      Uri.parse('$baseUrl/users/profile'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap);
    } else if (response.statusCode == 400) {
      throw ValidationException('Dados inválidos');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Unauthorized');
    } else {
      throw ServerException('Erro no servidor',
          statusCode: response.statusCode);
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final body = json.encode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });

    final response = await client.patch(
      Uri.parse('$baseUrl/users/change-password'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      final error = json.decode(response.body);
      throw ValidationException(error['message'] ?? 'Dados inválidos');
    } else if (response.statusCode == 401) {
    } else {
      throw ServerException(
          message: 'Erro no servidor',
          statusCode: response.statusCode);
    }
  }

  @override
  Future<void> deleteUser(String id) async {
  Future<void> deleteUser(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw NotFoundException('User not found');
    } else {
      throw ServerException(
          message: 'Erro no servidor',
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
  @override
  Future<List<UserModel>> getAllUsers() async {
    final response = await client.get(
      Uri.parse('$baseUrl/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
    } else {
      throw ServerException(
          message: 'Erro no servidor',
          statusCode: response.statusCode);
    }
  }
}
    }
  }
}
