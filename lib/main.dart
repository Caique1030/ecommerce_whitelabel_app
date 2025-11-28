import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_ecommerce/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_ecommerce/features/injection_container.dart' as di;
import 'package:flutter_ecommerce/features/products/presentation/pages/cart_page.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/client/presentation/provider/whitelabel_provider.dart';
import 'features/products/domain/usecases/cart_provider.dart';
import 'core/theme/whitelabel_theme.dart';
import 'core/navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  String get _currentHost {
    try {
      final host = Uri.base.host;
      return host;
    } catch (e) {
      return 'localhost';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = WhitelabelTheme.getTheme(_currentHost);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>.value(
          value: di.sl<CartProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<WhitelabelProvider>()..loadClientConfig(),
        ),
        
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) =>
                di.sl<AuthBloc>()..add(const CheckAuthenticationEvent()),
          ),
          BlocProvider<ProductsBloc>(create: (_) => di.sl<ProductsBloc>()),
        ],
        child: MaterialApp(
          title: 'E-Commerce',
          debugShowCheckedModeBanner: false,
          theme: theme,

          initialRoute: '/auth-check',

          routes: {
            '/auth-check': (context) {
              final state = context.watch<AuthBloc>().state;

              if (state is AuthLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is Authenticated) {
                return const MainNavigation();
              }

              return const LoginPage();
            },
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const MainNavigation(),
            '/cart': (context) => const CartPage(),
          },
        ),
      ),
    );
  }
}
