import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/cart_page.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/category_page.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/more_page.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/offers_page.dart';
import 'package:flutter_ecommerce/features/products/presentation/pages/products_list_page.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/cart_provider.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _pages = [
      const ProductsListPage(),
      const CategoriesPage(),
      const CartPage(),
      const OffersPage(),
      const MorePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Início',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  activeIcon: Icon(Icons.grid_view),
                  label: 'Categorias',
                ),
                BottomNavigationBarItem(
                  icon: _buildCartIcon(cart, isActive: false),
                  activeIcon: _buildCartIcon(cart, isActive: true),
                  label: 'Carrinho',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer_outlined),
                  activeIcon: Icon(Icons.local_offer),
                  label: 'Ofertas',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  activeIcon: Icon(Icons.menu),
                  label: 'Mais',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartIcon(CartProvider cart, {required bool isActive}) {
    final iconWidget = Icon(
      isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined,
    );

    if (cart.totalQuantity == 0) {
      return iconWidget;
    }

    return Badge(
      label: Text(
        '${cart.totalQuantity}',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      child: iconWidget,
    );
  }
}
