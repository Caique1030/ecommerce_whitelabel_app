import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsSyncing extends ProductsState {
  const ProductsSyncing();
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final String? currentFilter;

  const ProductsLoaded({required this.products, this.currentFilter});

  @override
  List<Object?> get props => [products, currentFilter];
}

class ProductLoaded extends ProductsState {
  final Product product;

  const ProductLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductsEmpty extends ProductsState {
  const ProductsEmpty();
}

class ProductCreatedSuccess extends ProductsState {
  final Product product;

  const ProductCreatedSuccess({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductUpdatedSuccess extends ProductsState {
  final Product product;

  const ProductUpdatedSuccess({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductDeletedSuccess extends ProductsState {
  final String productId;

  const ProductDeletedSuccess({required this.productId});

  @override
  List<Object?> get props => [productId];
}
