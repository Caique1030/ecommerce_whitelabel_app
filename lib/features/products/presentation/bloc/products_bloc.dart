import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/filter_products.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_id.dart';
import '../../domain/usecases/sync_product.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;
  final GetProductById getProductById;
  final FilterProducts filterProducts;
  final SyncProducts syncProducts;

  ProductsBloc({
    required this.getProducts,
    required this.getProductById,
    required this.filterProducts,
    required this.syncProducts,
  }) : super(const ProductsInitial()) {
    on<SyncProductsEvent>(_onSyncProducts);
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<FilterProductsEvent>(_onFilterProducts);
    on<ResetFilters>(_onResetFilters);
  }

  /// Sincroniza produtos dos fornecedores
  Future<void> _onSyncProducts(
    SyncProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsSyncing());

    final result = await syncProducts();

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (_) async {
        // Após sincronizar, carrega os produtos
        add(const LoadProducts(forceRefresh: true));
      },
    );
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await getProducts(
      GetProductsParams(
        limit: -1, // ✅ Adicione isso
        forceRefresh: event.forceRefresh, // ✅ Adicione isso
      ),
    );

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (products) {
        if (products.isEmpty) {
          emit(const ProductsEmpty());
        } else {
          emit(ProductsLoaded(products: products));
        }
      },
    );
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

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (products) {
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
      },
    );
  }

  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await getProducts(
      const GetProductsParams(
        limit: -1, // ✅ Adicione isso
      ),
    );

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (products) {
        if (products.isEmpty) {
          emit(const ProductsEmpty());
        } else {
          emit(ProductsLoaded(products: products));
        }
      },
    );
  }


  

}
