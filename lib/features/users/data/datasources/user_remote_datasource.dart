import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../../../../core/errors/exceptions.dart';


abstract class UserRemoteDataSource {
Future<UserModel> getUser(String id);
Future<UserModel> updateUser(String id, UserModel user);
}


class UserRemoteDataSourceImpl implements UserRemoteDataSource {
final http.Client client;
final String baseUrl;


UserRemoteDataSourceImpl({required this.client, required this.baseUrl});


@override
Future<UserModel> getUser(String id) async {
final response = await client.get(Uri.parse('\$baseUrl/users/\$id'));


if (response.statusCode == 200) {
final jsonMap = json.decode(response.body);
return UserModel.fromJson(jsonMap);
} else if (response.statusCode == 404) {
throw NotFoundException('User not found');
} else {
throw ServerException('Erro no servidor', statusCode: response.statusCode);
}
}


@override
Future<UserModel> updateUser(String id, UserModel user) async {
final body = json.encode(user.toJson());
final response = await client.patch(
Uri.parse('\$baseUrl/users/\$id'),
headers: {'Content-Type': 'application/json'},
body: body,
);


if (response.statusCode == 200) {
final jsonMap = json.decode(response.body);
return UserModel.fromJson(jsonMap);
} else if (response.statusCode == 400) {
throw ValidationException('Dados inválidos');
} else if (response.statusCode == 404) {
throw NotFoundException('User not found');
} else {
throw ServerException('Erro no servidor', statusCode: response.statusCode);
}
}
}