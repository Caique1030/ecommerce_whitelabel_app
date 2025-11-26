import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
=======
import 'package:flutter_ecommerce/features/products/domain/usecases/cart_provider.dart';
import 'package:provider/provider.dart';
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return _buildEmptyCart();
          }
          return _buildCartItems(state);
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildCheckoutButton(state);
=======
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Meu Carrinho (${cart.totalQuantity})'),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              if (!cart.isEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _showClearCartDialog(context, cart),
                  tooltip: 'Limpar carrinho',
                ),
            ],
          ),
          body: cart.isEmpty ? _buildEmptyCart() : _buildCartItems(cart),
          bottomNavigationBar:
              !cart.isEmpty ? _buildCheckoutButton(cart) : null,
        );
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Seu carrinho está vazio',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Adicione produtos para começar suas compras',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
<<<<<<< HEAD
              // Voltar para a página inicial
              Navigator.pop(context);
=======
              // Volta para a página inicial através do Navigator
              Navigator.of(context).popUntil((route) => route.isFirst);
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Continuar Comprando'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildCartItems(CartState state) {
=======
  Widget _buildCartItems(CartProvider cart) {
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
<<<<<<< HEAD
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return _CartItemCard(
                item: item,
                onRemove: () {
                  context.read<CartBloc>().add(
                    RemoveFromCartEvent(productId: item.product.id),
                  );
                },
                onQuantityChanged: (newQuantity) {
                  context.read<CartBloc>().add(
                    UpdateQuantityEvent(
                      productId: item.product.id,
                      quantity: newQuantity,
                    ),
                  );
=======
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return _CartItemCard(
                item: item,
                onRemove: () {
                  _showRemoveItemDialog(context, cart, item);
                },
                onQuantityChanged: (newQuantity) {
                  cart.updateQuantity(item.product.id, newQuantity);
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
                },
              );
            },
          ),
        ),
<<<<<<< HEAD
        _buildSummary(state),
=======
        _buildSummary(cart),
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildSummary(CartState state) {
=======
  Widget _buildSummary(CartProvider cart) {
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
<<<<<<< HEAD
                'Subtotal (${state.totalItems} ${state.totalItems == 1 ? 'item' : 'itens'})',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'R\$ ${state.totalPrice.toStringAsFixed(2)}',
=======
                'Subtotal (${cart.totalQuantity} ${cart.totalQuantity == 1 ? 'item' : 'itens'})',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'R\$ ${cart.totalPrice.toStringAsFixed(2)}',
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Frete',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'Grátis',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
<<<<<<< HEAD
                'R\$ ${state.totalPrice.toStringAsFixed(2)}',
=======
                'R\$ ${cart.totalPrice.toStringAsFixed(2)}',
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildCheckoutButton(CartState state) {
=======
  Widget _buildCheckoutButton(CartProvider cart) {
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed:
              _isProcessing ? null : () => _processCheckout(context, cart),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Finalizar Compra',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  void _showRemoveItemDialog(
      BuildContext context, CartProvider cart, CartItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover item'),
        content: Text(
          'Deseja remover "${item.product.name}" do carrinho?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              cart.removeItem(item.product.id);
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item removido do carrinho'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Limpar carrinho'),
        content: const Text(
          'Deseja remover todos os itens do carrinho?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrinho limpo'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Limpar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processCheckout(BuildContext context, CartProvider cart) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simula o processamento da compra
      final success = await cart.checkout();

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      if (success) {
        // Mostra dialog de sucesso
        _showSuccessDialog(context);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao processar compra: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Compra Realizada!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Sua compra foi realizada com sucesso!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Obrigado pela preferência!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Volta para a página inicial
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Continuar Comprando',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const _CartItemCard({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.product.image != null
                    ? Image.network(
                        item.product.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                      )
                    : const Icon(Icons.image, size: 40),
              ),
            ),
            const SizedBox(width: 12),

            // Informações do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
<<<<<<< HEAD
                  Text(
                    'R\$ ${item.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
=======

                  // Preço unitário
                  if (item.product.hasDiscount) ...[
                    Text(
                      'R\$ ${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
                    ),
                    Text(
                      'R\$ ${item.product.finalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                  ] else
                    Text(
                      'R\$ ${item.product.finalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Controles de quantidade e total
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () {
<<<<<<< HEAD
                                final currentQty = item.quantity;
                                if (currentQty > 1) {
                                  onQuantityChanged(currentQty - 1);
=======
                                if (item.quantity > 1) {
                                  onQuantityChanged(item.quantity - 1);
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
                                }
                              },
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () {
<<<<<<< HEAD
                                final currentQty = item.quantity;
                                onQuantityChanged(currentQty + 1);
=======
                                onQuantityChanged(item.quantity + 1);
>>>>>>> a4fc3639cd10a0fd867c95fa660e096105e523bf
                              },
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Total do item
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'R\$ ${item.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),

                      IconButton(
                        icon:
                            Icon(Icons.delete_outline, color: Colors.red[400]),
                        onPressed: onRemove,
                      ),
                    ],
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