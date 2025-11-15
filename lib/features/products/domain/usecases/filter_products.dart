import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class FilterProducts {
  final ProductsRepository repository;

  FilterProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(
    FilterProductsParams params,
  ) async {
    return await repository.getProducts(
      name: params.searchQuery,
      category: params.category,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
    );
  }
}

class FilterProductsParams extends Equatable {
  final String? searchQuery;
  final String? category;
  final double? minPrice;
  final double? maxPrice;

  const FilterProductsParams({
    this.searchQuery,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [searchQuery, category, minPrice, maxPrice];
}
