import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProducts {
  final ProductsRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      name: params.name,
      category: params.category,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      supplierId: params.supplierId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}

class GetProductsParams extends Equatable {
  final String? name;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? supplierId;
  final int? offset;
  final int? limit;

  const GetProductsParams({
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
