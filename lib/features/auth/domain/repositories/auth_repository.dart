import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Repositório abstrato para operações de autenticação
abstract class AuthRepository {
  /// Realiza o login do usuário
  ///
  /// Retorna [Right(User)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  /// Registra um novo usuário
  ///
  /// Retorna [Right(User)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  /// Realiza o logout do usuário
  ///
  /// Retorna [Right(void)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, void>> signOut();

  /// Obtém o usuário atual logado
  ///
  /// Retorna [Right(User?)] com o usuário se estiver logado ou null se não estiver
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, User?>> getCurrentUser();

  /// Verifica se há um usuário autenticado
  ///
  /// Retorna [true] se houver um usuário autenticado
  /// Retorna [false] caso contrário
  Future<bool> isAuthenticated();
}
