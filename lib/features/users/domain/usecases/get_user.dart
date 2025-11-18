import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';


class GetUser {
final UserRepository repository;


GetUser(this.repository);


Future<Either<Failure, User>> call(String id) async {
return await repository.getUser(id);
}
}