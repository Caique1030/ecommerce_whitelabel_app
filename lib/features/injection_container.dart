import 'package:flutter_ecommerce/core/network/api_client.dart';
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
import 'package:flutter_ecommerce/features/orders/data/repositories/order_repository_impl.dart';
import 'package:flutter_ecommerce/features/orders/domain/repositories/order_repository.dart';
import 'package:flutter_ecommerce/features/orders/domain/usecases/get_orders.dart';
import 'package:flutter_ecommerce/features/orders/presentation/bloc/order_bloc.dart';
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
  
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  
  sl.registerLazySingleton(
    () => ApiClient(httpClient: sl(), sharedPreferences: sl()),
  );

  
  
  
  sl.registerFactory(
    () => AuthBloc(signIn: sl(), signUp: sl(), signOut: sl(), repository: sl()),
  );

  
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl(), sharedPreferences: sl()),
  );

  
  
  sl.registerFactory(
    () => ProductsBloc(
      getProducts: sl(),
      getProductById: sl(),
      filterProducts: sl(),
      syncProducts: sl(),
    ),
  );

  sl.registerFactory(() => CartBloc());

  
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerLazySingleton(() => FilterProducts(sl()));
  sl.registerLazySingleton(() => SyncProducts(sl()));

  
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      remoteDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: sl()),
  );

  
  
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

  
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  sl.registerLazySingleton(() => GetAllUsers(sl()));

  
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      client: sl(),
      sharedPreferences: sl(),
    ),
  );

  
  
  sl.registerLazySingleton(() => WhitelabelProvider(getClientConfig: sl()));

  
  sl.registerLazySingleton(() => GetClientConfig(sl()));

  
  sl.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(remoteDataSource: sl(), sharedPreferences: sl()),
  );

  
  sl.registerLazySingleton<ClientRemoteDataSource>(
    () => ClientRemoteDataSourceImpl(apiClient: sl(), sharedPreferences: sl()),
  );

  
  
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(apiClient: sl()),
  );
  
  sl.registerLazySingleton(() => GetOrders(sl()));

  
  sl.registerFactory(() => OrderBloc(getOrders: sl()));

  
  sl.registerFactory<CartProvider>(() => CartProvider(orderRepository: sl()));
}
