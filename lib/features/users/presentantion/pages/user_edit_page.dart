import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_ecommerce/features/users/domain/entities/user.dart';
import 'package:flutter_ecommerce/features/users/presentantion/bloc/user_bloc.dart';
import 'package:flutter_ecommerce/features/users/presentantion/bloc/user_event.dart';
import 'package:flutter_ecommerce/features/users/presentantion/bloc/user_state.dart';
import 'package:flutter_ecommerce/features/injection_container.dart' as di;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        _nameController.text = authState.user.name;
        _emailController.text = authState.user.email;
        _phoneController.text = authState.user.phone ?? '';
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar autenticado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ USA OS DADOS ATUAIS E ATUALIZA APENAS OS CAMPOS EDITADOS
    final updatedUser = User(
      id: authState.user.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      avatarUrl: authState.user.avatarUrl, // ✅ MANTÉM O AVATAR ATUAL
      role: authState.user.role, // ✅ MANTÉM A ROLE ATUAL
      clientId: authState.user.clientId, // ✅ MANTÉM O CLIENT_ID ATUAL
    );

    // Dispara o evento de atualização
    context.read<UserBloc>().add(
          UpdateProfileEvent(user: updatedUser),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (_) => di.sl<UserBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) async {
            // ✅ GUARDA O CONTEXT ANTES DO ASYNC
            final currentContext = context;
            
            if (state is UserUpdated) {
              // ✅ ATUALIZAÇÃO CRÍTICA: Notifica o AuthBloc sobre a mudança
              currentContext.read<AuthBloc>().add(
                    UserProfileUpdated(user: state.user),
                  );

              // ✅ Mostra mensagem de sucesso
              ScaffoldMessenger.of(currentContext).showSnackBar(
                const SnackBar(
                  content: Text('Perfil atualizado com sucesso!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              // ✅ Aguarda um pouco e volta
              await Future.delayed(const Duration(milliseconds: 500));

              if (mounted) {
                Navigator.of(currentContext).pop(true);
              }
            } else if (state is UserError) {
              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, userState) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is! Authenticated) {
                  return const Center(
                    child: Text('Você precisa estar autenticado'),
                  );
                }

                final isLoading = userState is UserLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Avatar do usuário
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            authState.user.name.isNotEmpty
                                ? authState.user.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Editar Informações',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 32),

                        // Campo Nome
                        TextFormField(
                          controller: _nameController,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Nome Completo',
                            hintText: 'Digite seu nome completo',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira seu nome';
                            }
                            if (value.trim().length < 3) {
                              return 'Nome deve ter pelo menos 3 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo Email
                        TextFormField(
                          controller: _emailController,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'seu@email.com',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira seu email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value.trim())) {
                              return 'Por favor, insira um email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo Telefone
                        TextFormField(
                          controller: _phoneController,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Telefone (opcional)',
                            hintText: '(00) 00000-0000',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 32),

                        // Informações não editáveis
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Informações do Sistema',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text('Perfil: ${authState.user.role}'),
                              const SizedBox(height: 4),
                              Text('Cliente ID: ${authState.user.clientId}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Botão Salvar
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () => _updateProfile(context),
                            icon: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              isLoading ? 'Salvando...' : 'Salvar Alterações',
                              style: const TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Botão Cancelar
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.of(context).pop(false),
                            icon: const Icon(Icons.cancel),
                            label: const Text(
                              'Cancelar',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}