import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/products_repository.dart';

class SyncProducts {
  final ProductsRepository repository;

  SyncProducts(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.syncProducts();
  }
}
