import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/auth/domain/usecases/sing_in.dart';
import 'package:flutter_ecommerce/features/auth/domain/usecases/sing_out.dart';
import 'package:flutter_ecommerce/features/auth/domain/usecases/sing_up.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final AuthRepository repository;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.repository,
  }) : super(const AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthenticationEvent>(_onCheckAuthentication);
    on<UserProfileUpdated>(_onUserProfileUpdated); // ✅ NOVO HANDLER
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signIn(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signOut();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onCheckAuthentication(
    CheckAuthenticationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isAuth = await repository.isAuthenticated();

    if (isAuth) {
      final result = await repository.getCurrentUser();
      result.fold((failure) => emit(const Unauthenticated()), (user) {
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(const Unauthenticated());
        }
      });
    } else {
      emit(const Unauthenticated());
    }
  }

  // ✅ NOVO MÉTODO: Atualiza o usuário no estado Authenticated
  Future<void> _onUserProfileUpdated(
    UserProfileUpdated event,
    Emitter<AuthState> emit,
  ) async {
    if (state is Authenticated) {
      emit(Authenticated(user: event.user));
    }
  }
}