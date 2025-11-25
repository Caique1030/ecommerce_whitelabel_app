import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/cart_provider.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do produto
            if (widget.product.image != null)
              Image.network(
                widget.product.image!,
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
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Categoria
                  if (widget.product.category != null)
                    Chip(
                      label: Text(widget.product.category!),
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                    ),

                  const SizedBox(height: 16),

                  // Preço
                  Row(
                    children: [
                      if (widget.product.hasDiscount) ...[
                        Text(
                          'R\$ ${widget.product.price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.product.discountValue ?? 'OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'R\$ ${widget.product.finalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ] else
                        Text(
                          'R\$ ${widget.product.price.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Seletor de quantidade
                  Row(
                    children: [
                      Text(
                        'Quantidade:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  : null,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Descrição
                  if (widget.product.description != null) ...[
                    Text(
                      'Descrição',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Material
                  if (widget.product.material != null) ...[
                    _buildInfoRow(
                        context, 'Material', widget.product.material!),
                    const SizedBox(height: 8),
                  ],

                  // Departamento
                  if (widget.product.department != null) ...[
                    _buildInfoRow(
                        context, 'Departamento', widget.product.department!),
                    const SizedBox(height: 24),
                  ],

                  // Galeria
                  if (widget.product.gallery != null &&
                      widget.product.gallery!.isNotEmpty) ...[
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
                        itemCount: widget.product.gallery!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.product.gallery![index],
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

                  const SizedBox(height: 80), // Espaço para o botão fixo
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              final isInCart = cart.isInCart(widget.product.id);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInCart)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Produto já está no carrinho (${cart.getQuantity(widget.product.id)}x)',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cart.addItem(widget.product, quantity: _quantity);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isInCart
                                      ? 'Quantidade atualizada no carrinho!'
                                      : 'Produto adicionado ao carrinho!',
                                ),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'Ver Carrinho',
                                  onPressed: () {
                                    // Navega para o carrinho
                                    // Você pode ajustar isso de acordo com sua navegação
                                    Navigator.of(context).popUntil(
                                      (route) => route.isFirst,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            isInCart
                                ? Icons.add_shopping_cart
                                : Icons.shopping_cart,
                          ),
                          label: Text(
                            isInCart
                                ? 'Adicionar Mais'
                                : 'Adicionar ao Carrinho',
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      if (isInCart) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () {
                              cart.removeItem(widget.product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Produto removido do carrinho'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              );
            },
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
