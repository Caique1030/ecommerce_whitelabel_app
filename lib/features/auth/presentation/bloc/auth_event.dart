import 'package:equatable/equatable.dart';
import 'package:flutter_ecommerce/features/users/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [name, email, password, role];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class CheckAuthenticationEvent extends AuthEvent {
  const CheckAuthenticationEvent();
}
// ✅ NOVO EVENTO: Para atualizar o usuário no AuthBloc
class UserProfileUpdated extends AuthEvent {
  final User user;

  const UserProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}