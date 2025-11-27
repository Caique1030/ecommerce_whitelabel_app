import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce/features/products/domain/entities/product.dart';
import 'package:flutter_ecommerce/features/orders/domain/repositories/order_repository.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.finalPrice * quantity;

  // Método para converter em Map para a API
  Map<String, dynamic> toOrderItemMap() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'price': product.finalPrice,
    };
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  final OrderRepository orderRepository;

  CartProvider({required this.orderRepository});

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
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
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

  /// Finaliza a compra criando um pedido
  Future<bool> checkout() async {
    if (_items.isEmpty) {
      return false;
    }

    try {
      // Prepara os itens para o pedido
      final orderItems = _items.map((item) => item.toOrderItemMap()).toList();

      print('🛒 Criando pedido com ${orderItems.length} itens');
      print('💰 Total: R\$ $totalPrice');

      // Cria o pedido no backend
      final result = await orderRepository.createOrder(
        items: orderItems,
        total: totalPrice,
      );

      return result.fold(
        (failure) {
          print('❌ Falha ao criar pedido: ${failure.message}');
          return false;
        },
        (order) {
          print('✅ Pedido criado com sucesso: ${order.id}');
          // Limpa o carrinho apenas se o pedido foi criado com sucesso
          clear();
          return true;
        },
      );
    } catch (e) {
      print('❌ Erro durante checkout: $e');
      return false;
    }
  }
}