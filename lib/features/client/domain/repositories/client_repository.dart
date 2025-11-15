import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/features/client/domain/entities/client.dart';
import '../../../../core/errors/failures.dart';

abstract class ClientRepository {
  Future<Either<Failure, Client>> getClientConfig();
  Future<Either<Failure, Client>> getClientByDomain(String domain);
}
