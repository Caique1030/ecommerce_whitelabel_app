import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteUser(id);
  }
}
