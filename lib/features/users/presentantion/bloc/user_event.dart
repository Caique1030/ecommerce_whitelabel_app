// features/user/presentation/bloc/user_event.dart
import '../../domain/entities/user.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String id;

  LoadUser(this.id);
}

class UpdateUserEvent extends UserEvent {
  final String id;
  final User user;

  UpdateUserEvent({required this.id, required this.user});
}