import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class CreateProduct {
  final ProductsRepository repository;

  CreateProduct(this.repository);

  Future<Either<Failure, Product>> call(Product product) async {
    return await repository.createProduct(product);
  }
}
