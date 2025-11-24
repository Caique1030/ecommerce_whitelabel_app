import '../../domain/entities/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UsersLoaded extends UserState {
  final List<User> users;
  UsersLoaded(this.users);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserUpdated extends UserState {
  final User user;
  UserUpdated(this.user);
}

class PasswordChanged extends UserState {}

class UserDeleted extends UserState {}
