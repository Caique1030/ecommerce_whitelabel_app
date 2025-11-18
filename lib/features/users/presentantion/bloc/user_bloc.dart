import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/update_user.dart';
import 'user_event.dart';
import 'user_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
final GetUser getUser;
final UpdateUser updateUser;


UserBloc({required this.getUser, required this.updateUser}) : super(UserInitial()) {
on<LoadUser>((event, emit) async {
emit(UserLoading());
final result = await getUser(event.id);
result.fold(
(failure) => emit(UserError(_mapFailureToMessage(failure))),
(user) => emit(UserLoaded(user)),
);
});


on<UpdateUserEvent>((event, emit) async {
emit(UserLoading());
final result = await updateUser(UpdateUserParams(id: event.id, user: event.user));
result.fold(
(failure) => emit(UserError(_mapFailureToMessage(failure))),
(user) => emit(UserUpdated(user)),
);
});
}


String _mapFailureToMessage(Failure failure) {
if (failure is NotFoundFailure) return failure.message;
if (failure is ValidationFailure) return failure.message;
if (failure is NetworkFailure) return failure.message;
if (failure is ServerFailure) return failure.message;
return 'Erro inesperado';
}
}