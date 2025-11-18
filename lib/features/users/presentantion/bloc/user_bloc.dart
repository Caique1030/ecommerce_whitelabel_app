import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_all_users.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser getUser;
  final GetProfile getProfile;
  final UpdateUser updateUser;
  final UpdateProfile updateProfile;
  final ChangePassword changePassword;
  final DeleteUser deleteUser;
  final GetAllUsers getAllUsers;

  UserBloc({
    required this.getUser,
    required this.getProfile,
    required this.updateUser,
    required this.updateProfile,
    required this.changePassword,
    required this.deleteUser,
    required this.getAllUsers,
  }) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<LoadProfile>(_onLoadProfile);
    on<UpdateUserEvent>(_onUpdateUser);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteUserEvent>(_onDeleteUser);
    on<LoadAllUsersEvent>(_onLoadAllUsers);
  }

  // Carrega um usuário específico por ID
  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getUser(event.id);
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user)),
    );
  }

  // Carrega o perfil do usuário autenticado
  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getProfile();
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user)),
    );
  }

  // Atualiza um usuário específico (admin)
  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result =
        await updateUser(UpdateUserParams(id: event.id, user: event.user));
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (user) => emit(UserUpdated(user)),
    );
  }

  // Atualiza o perfil do usuário autenticado
  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await updateProfile(event.user);
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (user) => emit(UserUpdated(user)),
    );
  }

  // Altera a senha do usuário
  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await changePassword(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (_) => emit(PasswordChanged()),
    );
  }

  // Deleta um usuário
  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await deleteUser(event.id);
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (_) => emit(UserDeleted()),
    );
  }

  // Carrega todos os usuários
  Future<void> _onLoadAllUsers(
      LoadAllUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getAllUsers();
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (users) => emit(UsersLoaded(users)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NotFoundFailure) return failure.message;
    if (failure is ValidationFailure) return failure.message;
    if (failure is NetworkFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    if (failure is UnauthorizedFailure) return failure.message;
    return 'Erro inesperado';
  }
}
