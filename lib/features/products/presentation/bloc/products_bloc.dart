import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/products/domain/usecases/get_products_by_id.dart';
import '../../domain/usecases/filter_products.dart';
import '../../domain/usecases/get_products.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;
  final GetProductById getProductById;
  final FilterProducts filterProducts;

  ProductsBloc({
    required this.getProducts,
    required this.getProductById,
    required this.filterProducts,
  }) : super(const ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<FilterProductsEvent>(_onFilterProducts);
    on<ResetFilters>(_onResetFilters);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await getProducts(
      GetProductsParams(
        name: event.name,
        category: event.category,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        supplierId: event.supplierId,
        offset: event.offset,
        limit: event.limit,
      ),
    );

    result.fold((failure) => emit(ProductsError(message: failure.message)), (
      products,
    ) {
      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        emit(ProductsLoaded(products: products));
      }
    });
  }

  Future<void> _onLoadProductById(
    LoadProductById event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await getProductById(event.id);

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (product) => emit(ProductLoaded(product: product)),
    );
  }

  Future<void> _onFilterProducts(
    FilterProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await filterProducts(
      FilterProductsParams(
        searchQuery: event.searchQuery,
        category: event.category,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      ),
    );

    result.fold((failure) => emit(ProductsError(message: failure.message)), (
      products,
    ) {
      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        String filterDesc = '';
        if (event.searchQuery != null) filterDesc += event.searchQuery!;
        if (event.category != null) {
          filterDesc += (filterDesc.isNotEmpty ? ', ' : '') + event.category!;
        }

        emit(
          ProductsLoaded(
            products: products,
            currentFilter: filterDesc.isNotEmpty ? filterDesc : null,
          ),
        );
      }
    });
  }

  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await getProducts(const GetProductsParams());

    result.fold((failure) => emit(ProductsError(message: failure.message)), (
      products,
    ) {
      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        emit(ProductsLoaded(products: products));
      }
    });
  }
}
