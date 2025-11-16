import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    super.image,
    super.gallery,
    super.category,
    super.material,
    super.department,
    super.discountValue,
    super.hasDiscount,
    super.details,
    super.externalId,
    super.supplierId,
    super.clientId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] is String)
          ? double.parse(json['price'] as String)
          : (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      gallery: json['gallery'] != null
          ? List<String>.from(json['gallery'] as List)
          : null,
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

  Product toEntity() {
    return Product(
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
