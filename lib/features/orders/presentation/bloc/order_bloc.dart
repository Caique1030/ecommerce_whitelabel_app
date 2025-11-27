import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/orders/domain/entities/order.dart';
import 'package:flutter_ecommerce/features/orders/domain/usecases/get_orders.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrders getOrders;

  OrderBloc({required this.getOrders}) : super(OrderInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await getOrders();
    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }
}