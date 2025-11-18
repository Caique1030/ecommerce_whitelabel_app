import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, User>> updateUser(String id, User user);
  Future<Either<Failure, User>> updateProfile(User user);
  Future<Either<Failure, void>> changePassword(
      String oldPassword, String newPassword);
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, List<User>>> getAllUsers();
}
