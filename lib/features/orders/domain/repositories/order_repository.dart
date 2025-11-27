import 'package:dartz/dartz.dart' hide Order;
import '../entities/order.dart';
import '../../../../core/errors/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder({
    required List<Map<String, dynamic>> items,
    required double total,
  });

  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, Order>> getOrderById(String id);
}