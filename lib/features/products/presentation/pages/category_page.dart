import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/products_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/products_event.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/products_detail_page.dart';

import '../../domain/entities/product.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  // Lista de categorias disponíveis
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Eletrônicos', 'icon': Icons.devices, 'color': Color(0xFF3498db)},
    {'name': 'Roupas', 'icon': Icons.checkroom, 'color': Color(0xFFe74c3c)},
    {'name': 'Livros', 'icon': Icons.menu_book, 'color': Color(0xFFf39c12)},
    {'name': 'Casa', 'icon': Icons.home, 'color': Color(0xFF2ecc71)},
    {
      'name': 'Esportes',
      'icon': Icons.sports_soccer,
      'color': Color(0xFF9b59b6)
    },
    {'name': 'Beleza', 'icon': Icons.spa, 'color': Color(0xFFe91e63)},
    {'name': 'Brinquedos', 'icon': Icons.toys, 'color': Color(0xFF00bcd4)},
    {'name': 'Alimentos', 'icon': Icons.restaurant, 'color': Color(0xFF4caf50)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GridView.builder(
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
            name: category['name'],
            icon: category['icon'],
            color: category['color'],
            onTap: () {
              // Navegar para lista de produtos filtrada por categoria
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProductsBloc>()
                      ..add(FilterProductsEvent(category: category['name'])),
                    child:
                        _CategoryProductsPage(categoryName: category['name']),
                  ),
                ),
              );
            },
          );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de produtos por categoria
class _CategoryProductsPage extends StatelessWidget {
  final String categoryName;

  const _CategoryProductsPage({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductsBloc>().add(
                            FilterProductsEvent(category: categoryName),
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
                return _ProductCard(
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
    );
  }
}

// ✅ Card de produto CORRIGIDO - SEM OVERFLOW
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({Key? key, required this.product, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Imagem - Tamanho fixo ao invés de Expanded
            SizedBox(
              height: 140, // Altura fixa para evitar overflow
              child: product.image != null
                  ? Image.network(
                      product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),

            // ✅ Informações - Padding maior e sem Expanded
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // ✅ IMPORTANTE: min ao invés de max
                children: [
                  // Nome do produto
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.2, // ✅ Controla o espaçamento entre linhas
                    ),
                  ),
                  const SizedBox(height: 8), // ✅ Espaçamento fixo

                  // Preço
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
