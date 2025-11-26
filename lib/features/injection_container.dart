import 'package:flutter_ecommerce/core/network/api_client.dart';
import 'package:flutter_ecommerce/core/services/socket_io_service.dart';
import 'package:flutter_ecommerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_ecommerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_ecommerce/features/auth/domain/usecases/sing_in.dart';
import 'package:flutter_ecommerce/features/auth/domain/usecases/sing_out.dart';
import 'package:flutter_ecommerce/features/auth/domain/usecases/sing_up.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/client/data/datasources/client_remote_datasource.dart';
import 'package:flutter_ecommerce/features/client/data/repositories/client_repository_impl.dart';
import 'package:flutter_ecommerce/features/client/domain/repositories/client_repository.dart';
import 'package:flutter_ecommerce/features/client/domain/usecases/GetClientConfig.dart';
import 'package:flutter_ecommerce/features/client/presentation/provider/whitelabel_provider.dart';
import 'package:flutter_ecommerce/features/products/data/datasources/product_remote_datasources.dart';
import 'package:flutter_ecommerce/features/products/data/repositories/products_repository_impl.dart';
import 'package:flutter_ecommerce/features/products/domain/repositories/products_repository.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/cart_provider.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/filter_products.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/get_products.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/get_products_by_id.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/sync_product.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/cart_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/products_bloc.dart';
import 'package:flutter_ecommerce/features/users/data/datasources/user_remote_datasource.dart';
import 'package:flutter_ecommerce/features/users/data/repositories/user_repository_impl.dart';
import 'package:flutter_ecommerce/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_ecommerce/features/users/domain/usecases/change_password.dart';
import 'package:flutter_ecommerce/features/users/domain/usecases/delete_user.dart';
import 'package:flutter_ecommerce/features/users/domain/usecases/get_all_users.dart';
import 'package:flutter_ecommerce/features/users/domain/usecases/get_profile.dart';
import 'package:flutter_ecommerce/features/users/domain/usecases/get_user.dart';
import 'package:flutter_ecommerce/features/users/domain/usecases/update_profile.dart';
import 'package:flutter_ecommerce/features/users/domain/usecases/update_user.dart';
import 'package:flutter_ecommerce/features/users/presentantion/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(signIn: sl(), signUp: sl(), signOut: sl(), repository: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl(), sharedPreferences: sl()),
  );

  //! Features - Products
  // Bloc
  sl.registerFactory(
    () => ProductsBloc(
      getProducts: sl(),
      getProductById: sl(),
      filterProducts: sl(),
      syncProducts: sl(),
    ),
  );

  sl.registerFactory(() => CartBloc());

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerLazySingleton(() => FilterProducts(sl()));
  sl.registerLazySingleton(() => SyncProducts(sl()));

  // Repository
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      remoteDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Features - Users
  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getUser: sl(),
      getProfile: sl(),
      updateUser: sl(),
      updateProfile: sl(),
      changePassword: sl(),
      deleteUser: sl(),
      getAllUsers: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  sl.registerLazySingleton(() => GetAllUsers(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      client: sl(),
      sharedPreferences: sl(),
    ),
  );

  //! Features - Client
  // Provider
  sl.registerLazySingleton(() => WhitelabelProvider(getClientConfig: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetClientConfig(sl()));

  // Repository
  sl.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(remoteDataSource: sl(), sharedPreferences: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ClientRemoteDataSource>(
    () => ClientRemoteDataSourceImpl(apiClient: sl(), sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(
    () => ApiClient(httpClient: sl(), sharedPreferences: sl()),
  );

  // Socket.IO Service
  sl.registerLazySingleton(
    () => SocketIOService(sharedPreferences: sl()),
  );

  // Cart Provider
  sl.registerLazySingleton(() => CartProvider());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
