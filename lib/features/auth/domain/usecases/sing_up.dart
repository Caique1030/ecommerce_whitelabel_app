import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ecommerce/features/users/domain/entities/user.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String role;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [name, email, password, role];
}
