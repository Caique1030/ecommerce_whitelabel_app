import 'package:flutter_ecommerce/features/products/domain/entities/product.dart';

class CartState {
  final List<CartItem> items;

  CartState({required this.items});

  double get totalPrice {
    return items.fold(0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}