import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/filter_products.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_id.dart';
import '../../domain/usecases/sync_product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;
  final GetProductById getProductById;
  final FilterProducts filterProducts;
  final SyncProducts syncProducts;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductsBloc({
    required this.getProducts,
    required this.getProductById,
    required this.filterProducts,
    required this.syncProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(const ProductsInitial()) {
    on<SyncProductsEvent>(_onSyncProducts);
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<FilterProductsEvent>(_onFilterProducts);
    on<ResetFilters>(_onResetFilters);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
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
        add(const LoadProducts());
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
        name: event.name,
        category: event.category,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        supplierId: event.supplierId,
        offset: event.offset,
        limit: event.limit,
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

    final result = await getProducts(const GetProductsParams());

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

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await createProduct(event.product);

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (product) {
        emit(ProductCreatedSuccess(product: product));
        // Recarrega a lista após criar
        add(const LoadProducts());
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await updateProduct(
      UpdateProductParams(
        id: event.id,
        product: event.product,
      ),
    );

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (product) {
        emit(ProductUpdatedSuccess(product: product));
        // Recarrega a lista após atualizar
        add(const LoadProducts());
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = await deleteProduct(event.id);

    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (_) {
        emit(ProductDeletedSuccess(productId: event.id));
        // Recarrega a lista após deletar
        add(const LoadProducts());
      },
    );
  }
}
