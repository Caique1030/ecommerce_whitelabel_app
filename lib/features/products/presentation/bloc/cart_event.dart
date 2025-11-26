// features/cart/presentation/bloc/cart_event.dart
import 'package:flutter_ecommerce/features/products/domain/entities/product.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  AddToCartEvent({required this.product, this.quantity = 1});
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;

  RemoveFromCartEvent({required this.productId});
}

class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;

  UpdateQuantityEvent({required this.productId, required this.quantity});
}

class ClearCartEvent extends CartEvent {}