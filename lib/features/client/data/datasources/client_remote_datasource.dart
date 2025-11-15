import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/client_model.dart';

abstract class ClientRemoteDataSource {
  Future<ClientModel> getClientConfig();
  Future<ClientModel> getClientByDomain(String domain);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ClientRemoteDataSourceImpl({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<ClientModel> getClientConfig() async {
    try {
      // Primeiro tenta pegar do cache
      final cachedConfig = sharedPreferences.getString(
        AppConstants.clientConfigKey,
      );

      if (cachedConfig != null) {
        final json = jsonDecode(cachedConfig);
        return ClientModel.fromJson(json);
      }

      // Se não tiver em cache, busca da API
      final response = await apiClient.get(
        '${AppConstants.clientsEndpoint}/current',
        requiresAuth: false,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      // Salva no cache
      await sharedPreferences.setString(
        AppConstants.clientConfigKey,
        jsonEncode(response),
      );

      return ClientModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to get client config: ${e.toString()}',
      );
    }
  }

  @override
  Future<ClientModel> getClientByDomain(String domain) async {
    try {
      final response = await apiClient.get(
        '${AppConstants.clientsEndpoint}/current',
        requiresAuth: false,
      );

      if (response == null) {
        throw NotFoundException(message: 'Client not found');
      }

      return ClientModel.fromJson(response);
    } catch (e) {
      if (e is NotFoundException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to get client by domain: ${e.toString()}',
      );
    }
  }
}
