import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });


  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, void>> signOut();


  Future<Either<Failure, User?>> getCurrentUser();

  Future<bool> isAuthenticated();
}
