import 'package:bloc/bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(items: [])) {
    on<AddToCartEvent>(_addToCart);
    on<RemoveFromCartEvent>(_removeFromCart);
    on<UpdateQuantityEvent>(_updateQuantity);
    on<ClearCartEvent>(_clearCart);
  }

  void _addToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final existingIndex = items.indexWhere((item) => item.product.id == event.product.id);
    
    if (existingIndex >= 0) {
      items[existingIndex].quantity += event.quantity;
    } else {
      items.add(CartItem(product: event.product, quantity: event.quantity));
    }
    
    emit(CartState(items: items));
  }

  void _removeFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final items = state.items.where((item) => item.product.id != event.productId).toList();
    emit(CartState(items: items));
  }

  void _updateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.product.id == event.productId);
    
    if (index >= 0) {
      if (event.quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = event.quantity;
      }
    }
    
    emit(CartState(items: items));
  }

  void _clearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(CartState(items: []));
  }
}