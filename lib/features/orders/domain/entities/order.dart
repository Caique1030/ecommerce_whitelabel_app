class Order {
  final String id;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: (json['total'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final String id;
  final int quantity;
  final double price;
  final String productId;
  final String productName;
  final String? productImage;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.productName,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      productId: json['productId'],
      productName: json['product']?['name'] ?? 'Produto não encontrado',
      productImage: json['product']?['image'],
    );
  }

  double get total => price * quantity;
}