import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/order.dart' as order_entity;
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final String baseUrl;
  final String token;
  final String clientDomain; // Adicionar domínio do cliente

  OrderRepositoryImpl({
    required this.baseUrl, 
    required this.token,
    required this.clientDomain, // Novo parâmetro
  });

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Client-Domain': clientDomain, // Header necessário
    };
  }

  @override
  Future<Either<Failure, order_entity.Order>> createOrder({
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: _getHeaders(), // Usar headers com cliente
        body: jsonEncode({
          'items': items,
          'total': total,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final orderData = jsonDecode(response.body);
        return Right(order_entity.Order.fromJson(orderData));
      } else if (response.statusCode == 401) {
        return Left(ServerFailure(message: 'Não autorizado. Token inválido ou expirado.'));
      } else {
        return Left(ServerFailure(message: 'Falha ao criar pedido: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<order_entity.Order>>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: _getHeaders(), // Usar headers com cliente
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = jsonDecode(response.body);
        final orders = ordersJson.map((orderJson) => order_entity.Order.fromJson(orderJson)).toList();
        return Right(orders);
      } else if (response.statusCode == 401) {
        return Left(ServerFailure(message: 'Não autorizado. Token inválido ou expirado.'));
      } else {
        return Left(ServerFailure(message: 'Falha ao buscar pedidos: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, order_entity.Order>> getOrderById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/$id'),
        headers: _getHeaders(), // Usar headers com cliente
      );

      if (response.statusCode == 200) {
        return Right(order_entity.Order.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Left(ServerFailure(message: 'Não autorizado. Token inválido ou expirado.'));
      } else {
        return Left(ServerFailure(message: 'Falha ao buscar pedido: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}