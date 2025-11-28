
import 'package:flutter_ecommerce/features/users/domain/entities/user.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String id;

  LoadUser(this.id);
}

class LoadProfile extends UserEvent {}

class UpdateUserEvent extends UserEvent {
  final String id;
  final User user;

  UpdateUserEvent({required this.id, required this.user});
}

class UpdateProfileEvent extends UserEvent {
  final User user;

  UpdateProfileEvent({required this.user});
}

class ChangePasswordEvent extends UserEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}

class DeleteUserEvent extends UserEvent {
  final String id;

  DeleteUserEvent(this.id);
}

class LoadAllUsersEvent extends UserEvent {}