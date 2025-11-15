import 'package:flutter_ecommerce/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    String? description,
    required double price,
    String? image,
    List<String>? gallery,
    String? category,
    String? material,
    String? department,
    String? discountValue,
    bool hasDiscount = false,
    Map<String, dynamic>? details,
    String? externalId,
    String? supplierId,
    String? clientId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          image: image,
          gallery: gallery,
          category: category,
          material: material,
          department: department,
          discountValue: discountValue,
          hasDiscount: hasDiscount,
          details: details,
          externalId: externalId,
          supplierId: supplierId,
          clientId: clientId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: _parsePrice(json['price']),
      image: json['image'] as String?,
      gallery: _parseGallery(json['gallery']),
      category: json['category'] as String?,
      material: json['material'] as String?,
      department: json['department'] as String?,
      discountValue: json['discountValue'] as String?,
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      details: json['details'] as Map<String, dynamic>?,
      externalId: json['externalId'] as String?,
      supplierId: json['supplierId'] as String?,
      clientId: json['clientId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      // Remove símbolos de moeda e espaços
      final cleanPrice = price.replaceAll(RegExp(r'[^\d.,]'), '');
      return double.tryParse(cleanPrice.replaceAll(',', '.')) ?? 0.0;
    }
    return 0.0;
  }

  static List<String>? _parseGallery(dynamic gallery) {
    if (gallery == null) return null;
    if (gallery is List) {
      return gallery.map((e) => e.toString()).toList();
    }
    if (gallery is String) {
      // Se for uma string separada por vírgulas
      return gallery.split(',').map((e) => e.trim()).toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'gallery': gallery,
      'category': category,
      'material': material,
      'department': department,
      'discountValue': discountValue,
      'hasDiscount': hasDiscount,
      'details': details,
      'externalId': externalId,
      'supplierId': supplierId,
      'clientId': clientId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      image: product.image,
      gallery: product.gallery,
      category: product.category,
      material: product.material,
      department: product.department,
      discountValue: product.discountValue,
      hasDiscount: product.hasDiscount,
      details: product.details,
      externalId: product.externalId,
      supplierId: product.supplierId,
      clientId: product.clientId,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }
}
