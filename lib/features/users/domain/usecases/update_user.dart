import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';


class UpdateUser {
final UserRepository repository;


UpdateUser(this.repository);


Future<Either<Failure, User>> call(UpdateUserParams params) async {
return await repository.updateUser(params.id, params.user);
}
}


class UpdateUserParams {
final String id;
final User user;


UpdateUserParams({
required this.id,
required this.user,
});
}