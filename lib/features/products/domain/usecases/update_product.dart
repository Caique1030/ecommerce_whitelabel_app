import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class UpdateProductParams {
  final String id;
  final Product product;

  UpdateProductParams({
    required this.id,
    required this.product,
  });
}

class UpdateProduct {
  final ProductsRepository repository;

  UpdateProduct(this.repository);

  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.id, params.product);
  }
}
