import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_ecommerce/features/client/presentation/provider/whitelabel_provider.dart';
import 'package:flutter_ecommerce/features/injection_container.dart';
import 'package:flutter_ecommerce/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_ecommerce/features/orders/presentation/pages/orders_page.dart';
import 'package:flutter_ecommerce/features/users/presentantion/pages/user_edit_page.dart';
import 'package:flutter_ecommerce/features/users/presentantion/pages/change_password_page.dart';
import 'package:provider/provider.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          print('🔄 MorePage: AuthBloc state mudou - ${state.runtimeType}');

          if (state is Authenticated) {
            return _buildAuthenticatedContent(context, state);
          }
          return _buildUnauthenticatedContent(context);
        },
      ),
    );
  }

  Widget _buildAuthenticatedContent(BuildContext context, Authenticated state) {
    final whitelabelProvider = Provider.of<WhitelabelProvider>(context);
    final user = state.user;

    print('👤 MorePage: Renderizando perfil de ${user.name}');

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 8),

            _buildSectionHeader(context, 'Minha Conta'),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'Editar Perfil',
              subtitle: 'Alterar nome e informações',
              onTap: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );

                if (result == true && mounted) {
                  context
                      .read<AuthBloc>()
                      .add(const CheckAuthenticationEvent());
                }
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.lock_outline,
              title: 'Alterar Senha',
              subtitle: 'Trocar sua senha de acesso',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ),
                );
              },
            ),

            const Divider(height: 32),
            _buildMenuItem(
              context,
              icon: Icons.shopping_bag_outlined,
              title: 'Meus Pedidos',
              subtitle: 'Acompanhe o status dos seus pedidos',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => sl<OrderBloc>(),
                      child: const OrdersPage(),
                    ),
                  ),
                );
              },
            ),

            const Divider(height: 32),

            _buildSectionHeader(context, 'Informações'),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'Sobre',
              subtitle: whitelabelProvider.client?.name ?? 'E-Commerce',
              onTap: () {
                _showAboutDialog(context, whitelabelProvider);
              },
            ),

           

            const Divider(height: 32),

            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Sair da Conta',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ]),
        ),
      ],
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Você não está logado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Faça login para acessar suas informações',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('Fazer Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const SignOutRequested());
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(
      BuildContext context, WhitelabelProvider whitelabelProvider) {
    showAboutDialog(
      context: context,
      applicationName: whitelabelProvider.client?.name ?? 'E-Commerce',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.shopping_bag,
        size: 48,
        color: Theme.of(context).primaryColor,
      ),
      children: [
        const Text('Aplicativo de e-commerce com recursos avançados.'),
        const SizedBox(height: 16),
        const Text('Desenvolvido com Flutter e Clean Architecture.'),
      ],
    );
  }
}
