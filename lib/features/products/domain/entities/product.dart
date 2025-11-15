import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final List<String>? gallery;
  final String? category;
  final String? material;
  final String? department;
  final String? discountValue;
  final bool hasDiscount;
  final Map<String, dynamic>? details;
  final String? externalId;
  final String? supplierId;
  final String? clientId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.gallery,
    this.category,
    this.material,
    this.department,
    this.discountValue,
    this.hasDiscount = false,
    this.details,
    this.externalId,
    this.supplierId,
    this.clientId,
    required this.createdAt,
    required this.updatedAt,
  });

  double get finalPrice {
    if (!hasDiscount || discountValue == null) {
      return price;
    }

    // Se o desconto for em porcentagem
    if (discountValue!.contains('%')) {
      final percentage =
          double.tryParse(discountValue!.replaceAll('%', '').trim()) ?? 0;
      return price - (price * percentage / 100);
    }

    // Se o desconto for um valor fixo
    final discount = double.tryParse(discountValue!) ?? 0;
    return price - discount;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    image,
    gallery,
    category,
    material,
    department,
    discountValue,
    hasDiscount,
    details,
    externalId,
    supplierId,
    clientId,
    createdAt,
    updatedAt,
  ];

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    List<String>? gallery,
    String? category,
    String? material,
    String? department,
    String? discountValue,
    bool? hasDiscount,
    Map<String, dynamic>? details,
    String? externalId,
    String? supplierId,
    String? clientId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      gallery: gallery ?? this.gallery,
      category: category ?? this.category,
      material: material ?? this.material,
      department: department ?? this.department,
      discountValue: discountValue ?? this.discountValue,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      details: details ?? this.details,
      externalId: externalId ?? this.externalId,
      supplierId: supplierId ?? this.supplierId,
      clientId: clientId ?? this.clientId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
