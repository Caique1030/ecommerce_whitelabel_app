import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class ChangePassword {
  final UserRepository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await repository.changePassword(
        params.oldPassword, params.newPassword);
  }
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });
}
