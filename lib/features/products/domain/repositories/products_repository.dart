import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
    int? offset,
    int? limit,
  });

  Future<Either<Failure, Product>> getProductById(String id);

  Future<Either<Failure, Product>> createProduct(Product product);

  Future<Either<Failure, Product>> updateProduct(String id, Product product);

  Future<Either<Failure, void>> deleteProduct(String id);

  Future<Either<Failure, void>> syncProducts();
}
