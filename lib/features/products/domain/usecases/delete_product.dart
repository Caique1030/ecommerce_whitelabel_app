import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/products_repository.dart';

class DeleteProduct {
  final ProductsRepository repository;

  DeleteProduct(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteProduct(id);
  }
}
