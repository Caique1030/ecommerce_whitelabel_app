import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para sincronizar produtos dos fornecedores
class SyncProductsEvent extends ProductsEvent {
  const SyncProductsEvent();
}

class LoadProducts extends ProductsEvent {
  final String? name;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? supplierId;
  final int? offset;
  final int? limit;
  final bool forceRefresh;

  const LoadProducts({
    this.name,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.supplierId,
    this.offset,
    this.limit,
    this.forceRefresh = false,
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

/// Evento para criar um novo produto
class CreateProductEvent extends ProductsEvent {
  final Product product;

  const CreateProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Evento para atualizar um produto
class UpdateProductEvent extends ProductsEvent {
  final String id;
  final Product product;

  const UpdateProductEvent({
    required this.id,
    required this.product,
  });

  @override
  List<Object?> get props => [id, product];
}

/// Evento para deletar um produto
class DeleteProductEvent extends ProductsEvent {
  final String id;

  const DeleteProductEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
