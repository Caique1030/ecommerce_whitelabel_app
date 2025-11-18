import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';


class UserRepositoryImpl implements UserRepository {
final UserRemoteDataSource remoteDataSource;


UserRepositoryImpl({required this.remoteDataSource});


@override
Future<Either<Failure, User>> getUser(String id) async {
try {
final userModel = await remoteDataSource.getUser(id);
return Right(userModel);
} on NotFoundException catch (e) {
return Left(NotFoundFailure(e.message));
} on ServerException catch (e) {
return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
} on NetworkException catch (e) {
return Left(NetworkFailure(e.message));
} catch (e) {
return Left(UnexpectedFailure('Unexpected error: \$e'));
}
}


@override
Future<Either<Failure, User>> updateUser(String id, User user) async {
try {
final model = UserModel.fromEntity(user);
final updated = await remoteDataSource.updateUser(id, model);
return Right(updated);
} on ValidationException catch (e) {
return Left(ValidationFailure(message: e.message));
} on NotFoundException catch (e) {
return Left(NotFoundFailure(e.message));
} on ServerException catch (e) {
return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
} on NetworkException catch (e) {
return Left(NetworkFailure(e.message));
} catch (e) {
return Left(UnexpectedFailure('Unexpected error: \$e'));
}
}
}