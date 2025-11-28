import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/products_detail_page.dart';
import 'package:flutter_ecommerce/features/products/presentation/widgets/products_filter.dart';
import 'package:flutter_ecommerce/features/products/presentation/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../client/presentation/provider/whitelabel_provider.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {

      print('📦 Carregando produtos...');
      context.read<ProductsBloc>().add(const LoadProducts());

      // 3. A sincronização só acontecerá se LoadProducts retornar vazio
      // (veja a lógica no ProductsBloc)
    } catch (e) {
      print('❌ Erro ao inicializar aplicação: $e');
      // Mesmo com erro, tenta carregar produtos existentes
      context.read<ProductsBloc>().add(const LoadProducts());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final whitelabelProvider = Provider.of<WhitelabelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(whitelabelProvider.client?.name ?? 'Início'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // Botão de busca
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
            tooltip: 'Buscar',
          ),
          // Botão para sincronizar manualmente
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<ProductsBloc>().add(const SyncProductsEvent());
            },
            tooltip: 'Sincronizar Produtos',
          ),
          // Botão de filtro
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
            tooltip: 'Filtrar Produtos',
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            // Estado de sincronização
            if (state is ProductsSyncing) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Sincronizando produtos dos fornecedores...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Isso pode levar alguns segundos',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            // Estado de carregamento
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Estado de erro
            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar produtos',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<ProductsBloc>()
                                .add(const SyncProductsEvent());
                          },
                          icon: const Icon(Icons.sync),
                          label: const Text('Sincronizar'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            context
                                .read<ProductsBloc>()
                                .add(const LoadProducts());
                          },
                          child: const Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            // Estado vazio
            if (state is ProductsEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum produto encontrado',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tente sincronizar ou ajustar os filtros',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<ProductsBloc>()
                                .add(const SyncProductsEvent());
                          },
                          icon: const Icon(Icons.sync),
                          label: const Text('Sincronizar'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            context
                                .read<ProductsBloc>()
                                .add(const ResetFilters());
                          },
                          child: const Text('Limpar Filtros'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            // Estado com produtos carregados
            if (state is ProductsLoaded) {
              return Column(
                children: [
                  // Banner de filtro ativo
                  if (state.currentFilter != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Filtro: ${state.currentFilter}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<ProductsBloc>().add(
                                    const ResetFilters(),
                                  );
                            },
                            child: const Text('Limpar'),
                          ),
                        ],
                      ),
                    ),

                  // Grid de produtos
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<ProductsBloc>()
                            .add(const SyncProductsEvent());
                      },
                      child: ProductGrid(
                        products: state.products,
                        onProductTap: (product) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            // Estado inicial
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Preparando aplicação...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ),

    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buscar Produto'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Nome do produto',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.of(dialogContext).pop();
              context.read<ProductsBloc>().add(
                    FilterProductsEvent(searchQuery: value.trim()),
                  );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.trim().isNotEmpty) {
                Navigator.of(dialogContext).pop();
                context.read<ProductsBloc>().add(
                      FilterProductsEvent(
                        searchQuery: _searchController.text.trim(),
                      ),
                    );
              }
            },
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ProductsBloc>(),
        child: const ProductFilter(),
      ),
    );
  }
}
