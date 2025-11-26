import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce/features/products/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.finalPrice * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool get isEmpty => _items.isEmpty;

  /// Adiciona um produto ao carrinho
  void addItem(Product product, {int quantity = 1}) {
    // Verifica se o produto já está no carrinho
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Se já existe, apenas aumenta a quantidade
      _items[existingIndex].quantity += quantity;
    } else {
      // Se não existe, adiciona novo item
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  /// Remove um produto do carrinho
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Atualiza a quantidade de um item
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  /// Incrementa a quantidade de um item
  void incrementQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrementa a quantidade de um item
  void decrementQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        removeItem(productId);
      }
    }
  }

  /// Verifica se um produto está no carrinho
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Obtém a quantidade de um produto no carrinho
  int getQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    return index >= 0 ? _items[index].quantity : 0;
  }

  /// Limpa o carrinho
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Finaliza a compra (apenas limpa o carrinho)
  Future<bool> checkout() async {
    // Simula um delay de processamento
    await Future.delayed(const Duration(seconds: 2));

    // Limpa o carrinho após "processar" a compra
    clear();

    return true;
  }
}
