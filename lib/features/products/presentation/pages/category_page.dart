import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/products_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/products_event.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/products_detail_page.dart';
import 'package:flutter_ecommerce/features/products/presentation/widgets/product_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  void _loadCategories() {
    context.read<ProductsBloc>().add(const ResetFilters());
  }

  IconData _getCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();

    if (categoryLower.contains('electronic') ||
        categoryLower.contains('eletrônic')) {
      return Icons.devices;
    } else if (categoryLower.contains('cloth') ||
        categoryLower.contains('roupa') ||
        categoryLower.contains('fashion')) {
      return Icons.checkroom;
    } else if (categoryLower.contains('book') ||
        categoryLower.contains('livro')) {
      return Icons.menu_book;
    } else if (categoryLower.contains('home') ||
        categoryLower.contains('casa') ||
        categoryLower.contains('garden')) {
      return Icons.home;
    } else if (categoryLower.contains('sport') ||
        categoryLower.contains('esporte')) {
      return Icons.sports_soccer;
    } else if (categoryLower.contains('beauty') ||
        categoryLower.contains('beleza')) {
      return Icons.spa;
    } else if (categoryLower.contains('toy') ||
        categoryLower.contains('brinquedo')) {
      return Icons.toys;
    } else if (categoryLower.contains('food') ||
        categoryLower.contains('alimento') ||
        categoryLower.contains('grocery')) {
      return Icons.restaurant;
    } else if (categoryLower.contains('tool') ||
        categoryLower.contains('ferramenta')) {
      return Icons.build;
    } else if (categoryLower.contains('health') ||
        categoryLower.contains('saúde')) {
      return Icons.local_hospital;
    } else if (categoryLower.contains('music') ||
        categoryLower.contains('música')) {
      return Icons.music_note;
    } else if (categoryLower.contains('movie') ||
        categoryLower.contains('filme')) {
      return Icons.movie;
    } else if (categoryLower.contains('computer') ||
        categoryLower.contains('computador')) {
      return Icons.computer;
    } else if (categoryLower.contains('shoe') ||
        categoryLower.contains('sapato') ||
        categoryLower.contains('calçado')) {
      return Icons.beach_access;
    } else if (categoryLower.contains('jewelry') ||
        categoryLower.contains('joia')) {
      return Icons.diamond;
    } else if (categoryLower.contains('baby') ||
        categoryLower.contains('bebê')) {
      return Icons.child_care;
    } else if (categoryLower.contains('kid') ||
        categoryLower.contains('criança')) {
      return Icons.child_friendly;
    } else if (categoryLower.contains('outdoor')) {
      return Icons.terrain;
    } else if (categoryLower.contains('game')) {
      return Icons.sports_esports;
    } else if (categoryLower.contains('industrial')) {
      return Icons.factory;
    } else {
      return Icons.category;
    }
  }

  Color _getCategoryColor(int index) {
    final colors = [
      const Color(0xFF3498db),
      const Color(0xFFe74c3c),
      const Color(0xFFf39c12),
      const Color(0xFF2ecc71),
      const Color(0xFF9b59b6),
      const Color(0xFFe91e63),
      const Color(0xFF00bcd4),
      const Color(0xFF4caf50),
      const Color(0xFFff9800),
      const Color(0xFF795548),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _loadCategories,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading || state is ProductsSyncing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCategories,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductsLoaded) {
            final categoriesSet = <String>{};
            for (var product in state.products) {
              if (product.category != null && product.category!.isNotEmpty) {
                categoriesSet.add(product.category!);
              }
            }

            final categories = categoriesSet.toList()..sort();

            if (categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma categoria encontrada',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadCategories();
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryCard(
                    name: category,
                    icon: _getCategoryIcon(category),
                    color: _getCategoryColor(index),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _CategoryProductsPage(
                            categoryName: category,
                            productsBloc: context.read<ProductsBloc>(),
                          ),
                        ),
                      );

                      if (mounted) {
                        context.read<ProductsBloc>().add(const ResetFilters());
                      }
                    },
                  );
                },
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    Key? key,
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryProductsPage extends StatefulWidget {
  final String categoryName;
  final ProductsBloc productsBloc;

  const _CategoryProductsPage({
    Key? key,
    required this.categoryName,
    required this.productsBloc,
  }) : super(key: key);

  @override
  State<_CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<_CategoryProductsPage> {
  @override
  void initState() {
    super.initState();
    widget.productsBloc.add(FilterProductsEvent(category: widget.categoryName));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.productsBloc.add(const ResetFilters());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.productsBloc.add(const ResetFilters());
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Limpar filtro e voltar',
              onPressed: () {
                widget.productsBloc.add(const ResetFilters());
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          bloc: widget.productsBloc,
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        widget.productsBloc.add(
                          FilterProductsEvent(category: widget.categoryName),
                        );
                      },
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductsEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum produto encontrado\nnesta categoria',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () {
                        widget.productsBloc.add(const ResetFilters());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductsLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

