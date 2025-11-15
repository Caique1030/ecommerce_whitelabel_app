import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/features/client/domain/entities/client.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/client_repository.dart';

class GetClientConfig {
  final ClientRepository repository;

  GetClientConfig(this.repository);

  Future<Either<Failure, Client>> call() async {
    return await repository.getClientConfig();
  }
}
