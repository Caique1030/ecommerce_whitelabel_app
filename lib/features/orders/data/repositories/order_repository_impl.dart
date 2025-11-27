import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/core/constants/app_constants.dart';
import 'package:flutter_ecommerce/core/errors/exceptions.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart';
import 'package:flutter_ecommerce/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:flutter_ecommerce/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient apiClient;

  OrderRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, order_entity.Order>> createOrder({
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    try {
      print('📦 Criando pedido: ${items.length} itens, total: R\$ $total');

      final response = await apiClient.post(
        AppConstants.ordersEndpoint, // Certifique-se que isso está definido
        body: {
          'items': items,
          'total': total,
        },
        requiresAuth: true,
      );

      if (response == null) {
        return Left(ServerFailure(message: 'Resposta inválida do servidor'));
      }

      print('✅ Pedido criado com sucesso: ${response['id']}');
      return Right(order_entity.Order.fromJson(response));
    } on UnauthorizedException catch (e) {
      print('❌ Erro de autenticação: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      print('❌ Erro do servidor: ${e.message}');
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      print('❌ Erro de rede: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      print('❌ Erro inesperado: $e');
      return Left(UnexpectedFailure('Erro ao criar pedido: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<order_entity.Order>>> getOrders() async {
    try {
      print('📋 Buscando pedidos do usuário...');

      final response = await apiClient.get(
        AppConstants.ordersEndpoint,
        requiresAuth: true,
      );

      if (response == null) {
        return Left(ServerFailure(message: 'Resposta inválida do servidor'));
      }

      final List<dynamic> ordersJson = response is List ? response : [];
      final orders = ordersJson
          .map((orderJson) => order_entity.Order.fromJson(orderJson))
          .toList();

      print('✅ ${orders.length} pedidos carregados');
      return Right(orders);
    } on UnauthorizedException catch (e) {
      print('❌ Erro de autenticação: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      print('❌ Erro do servidor: ${e.message}');
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      print('❌ Erro de rede: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      print('❌ Erro inesperado: $e');
      return Left(UnexpectedFailure('Erro ao buscar pedidos: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, order_entity.Order>> getOrderById(String id) async {
    try {
      print('📦 Buscando pedido $id...');

      final response = await apiClient.get(
        '${AppConstants.ordersEndpoint}/$id',
        requiresAuth: true,
      );

      if (response == null) {
        return Left(NotFoundFailure('Pedido não encontrado'));
      }

      print('✅ Pedido encontrado');
      return Right(order_entity.Order.fromJson(response));
    } on NotFoundException catch (e) {
      print('❌ Pedido não encontrado: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on UnauthorizedException catch (e) {
      print('❌ Erro de autenticação: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      print('❌ Erro do servidor: ${e.message}');
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      print('❌ Erro de rede: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      print('❌ Erro inesperado: $e');
      return Left(UnexpectedFailure('Erro ao buscar pedido: ${e.toString()}'));
    }
  }
}
