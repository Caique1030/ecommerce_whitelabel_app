import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/services/socket_io_service.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_ecommerce/features/injection_container.dart' as di;
import 'package:provider/provider.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/pages/products_list_page.dart';
import 'features/client/presentation/provider/whitelabel_provider.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<WhitelabelProvider>()..loadClientConfig(),
        ),
        Provider<SocketIOService>(
          create: (_) => di.sl<SocketIOService>(),
          dispose: (_, service) => service.disconnect(),
        ),
      ],
      child: Consumer<WhitelabelProvider>(
        builder: (context, whitelabelProvider, _) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (_) =>
                    di.sl<AuthBloc>()..add(CheckAuthenticationEvent()),
              ),
              BlocProvider<ProductsBloc>(create: (_) => di.sl<ProductsBloc>()),
            ],
            child: MaterialApp(
              title: whitelabelProvider.client?.name ?? 'E-Commerce',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.getTheme(
                primaryColor: whitelabelProvider.client?.primaryColorValue,
                secondaryColor: whitelabelProvider.client?.secondaryColorValue,
              ),
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is Authenticated) {
                    return const ProductsListPage();
                  }

                  return const LoginPage();
                },
              ),
              routes: {
                '/login': (context) => const LoginPage(),
                '/products': (context) => const ProductsListPage(),
              },
            ),
          );
        },
      ),
    );
  }
}
