import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/features/users/data/models/user_model.dart';
import 'package:flutter_ecommerce/features/users/domain/entities/user.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.signIn(
        email: email,
        password: password,
      );

      final userData = response['user'] as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userData);

      return Right(userModel);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado ao fazer login'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      final userData = response['user'] != null
          ? response['user'] as Map<String, dynamic>
          : response as Map<String, dynamic>;

      final userModel = UserModel.fromJson(userData);

      return Right(userModel);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Erro inesperado ao criar conta'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Erro ao fazer logout'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();

      if (userModel == null) {
        return const Right(null);
      }

      return Right(userModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Erro ao obter usuário atual'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}