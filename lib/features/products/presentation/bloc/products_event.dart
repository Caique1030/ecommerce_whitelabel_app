import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {
  final String? name;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? supplierId;
  final int? offset;
  final int? limit;

  const LoadProducts({
    this.name,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.supplierId,
    this.offset,
    this.limit,
  });

  @override
  List<Object?> get props => [
    name,
    category,
    minPrice,
    maxPrice,
    supplierId,
    offset,
    limit,
  ];
}

class LoadProductById extends ProductsEvent {
  final String id;

  const LoadProductById({required this.id});

  @override
  List<Object?> get props => [id];
}

class FilterProductsEvent extends ProductsEvent {
  final String? searchQuery;
  final String? category;
  final double? minPrice;
  final double? maxPrice;

  const FilterProductsEvent({
    this.searchQuery,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [searchQuery, category, minPrice, maxPrice];
}

class ResetFilters extends ProductsEvent {
  const ResetFilters();
}
