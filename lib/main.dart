import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/services/socket_io_service.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_ecommerce/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_ecommerce/features/injection_container.dart' as di;
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

  // ✅ Detecta o domínio atual imediatamente
  String get _currentHost {
    try {
      final host = Uri.base.host;
      print('🌐 Domínio detectado em main.dart: $host');
      return host;
    } catch (e) {
      print('⚠️ Erro ao detectar domínio: $e');
      return 'localhost';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Aplica o tema baseado no domínio IMEDIATAMENTE
    final theme = WhitelabelTheme.getTheme(_currentHost);
    print('🎨 Tema aplicado no main.dart para host: $_currentHost');

    return MultiProvider(
      providers: [
        // ✅ CRÍTICO: Usar a MESMA instância do Service Locator
        ChangeNotifierProvider<CartProvider>.value(
          value: di.sl<CartProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<WhitelabelProvider>()..loadClientConfig(),
        ),
        Provider<SocketIOService>(
          create: (_) => di.sl<SocketIOService>(),
          dispose: (_, service) => service.disconnect(),
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
          theme: theme, // ✅ Tema aplicado diretamente do domínio

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
          },
        ),
      ),
    );
  }
}
