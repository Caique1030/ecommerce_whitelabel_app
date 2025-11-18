import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';


abstract class UserRepository {
Future<Either<Failure, User>> getUser(String id);
Future<Either<Failure, User>> updateUser(String id, User user);
}