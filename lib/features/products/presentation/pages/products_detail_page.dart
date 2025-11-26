import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/cart_bloc.dart';
import 'package:flutter_ecommerce/features/products/presentation/bloc/cart_event.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do produto
            if (product.image != null)
              Image.network(
                product.image!,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              )
            else
              Container(
                height: 300,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 100, color: Colors.grey),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome do produto
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Categoria
                  if (product.category != null)
                    Chip(
                      label: Text(product.category!),
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                    ),

                  const SizedBox(height: 16),

                  // Preço
                  Row(
                    children: [
                      if (product.hasDiscount) ...[
                        Text(
                          'R\$ ${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'R\$ ${product.finalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ] else
                        Text(
                          'R\$ ${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Descrição
                  if (product.description != null) ...[
                    Text(
                      'Descrição',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Material
                  if (product.material != null) ...[
                    _buildInfoRow(context, 'Material', product.material!),
                    const SizedBox(height: 8),
                  ],

                  // Departamento
                  if (product.department != null) ...[
                    _buildInfoRow(context, 'Departamento', product.department!),
                    const SizedBox(height: 24),
                  ],

                  // Galeria
                  if (product.gallery != null &&
                      product.gallery!.isNotEmpty) ...[
                    Text(
                      'Galeria',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.gallery!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.gallery![index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
     // No ProductDetailPage, substitua o botão no bottomNavigationBar:
bottomNavigationBar: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: ElevatedButton(
      onPressed: () {
        // Adiciona o produto ao carrinho
        context.read<CartBloc>().add(AddToCartEvent(product: product));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto adicionado ao carrinho!'),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Adicionar ao Carrinho',
        style: TextStyle(fontSize: 16),
      ),
    ),
  ),
),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
