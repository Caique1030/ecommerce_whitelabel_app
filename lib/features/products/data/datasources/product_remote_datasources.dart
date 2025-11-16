import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  /// Obtém lista de produtos com filtros opcionais
  Future<List<ProductModel>> getProducts({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
    int? offset,
    int? limit,
  });

  /// Obtém um produto por ID
  Future<ProductModel> getProductById(String id);

  /// Cria um novo produto
  Future<ProductModel> createProduct(ProductModel product);

  /// Atualiza um produto existente
  Future<ProductModel> updateProduct(String id, ProductModel product);

  /// Remove um produto
  Future<void> deleteProduct(String id);

  /// Sincroniza produtos dos fornecedores
  Future<void> syncProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
    int? offset,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, String>{};

      if (name != null) queryParameters['name'] = name;
      if (category != null) queryParameters['category'] = category;
      if (minPrice != null) queryParameters['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParameters['maxPrice'] = maxPrice.toString();
      if (supplierId != null) queryParameters['supplierId'] = supplierId;
      if (offset != null) queryParameters['offset'] = offset.toString();
      if (limit != null) queryParameters['limit'] = limit.toString();

      final response = await apiClient.get(
        AppConstants.productsEndpoint,
        queryParameters: queryParameters,
        requiresAuth: false, // Produtos são públicos
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      // O backend retorna { products: [], total: number }
      final products = response['products'] as List;
      return products.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Failed to get products: ${e.toString()}',
      );
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await apiClient.get(
        '${AppConstants.productsEndpoint}/$id',
        requiresAuth: false,
      );

      if (response == null) {
        throw NotFoundException(message: 'Product not found');
      }

      return ProductModel.fromJson(response);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(
        message: 'Failed to get product: ${e.toString()}',
      );
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await apiClient.post(
        AppConstants.productsEndpoint,
        body: product.toJson(),
        requiresAuth: true,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      return ProductModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Failed to create product: ${e.toString()}',
      );
    }
  }

  @override
  Future<ProductModel> updateProduct(String id, ProductModel product) async {
    try {
      final response = await apiClient.patch(
        '${AppConstants.productsEndpoint}/$id',
        body: product.toJson(),
        requiresAuth: true,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      return ProductModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Failed to update product: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await apiClient.delete(
        '${AppConstants.productsEndpoint}/$id',
        requiresAuth: true,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Failed to delete product: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> syncProducts() async {
    try {
      await apiClient.post(
        '${AppConstants.productsEndpoint}/sync',
        body: {},
        requiresAuth: true,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Failed to sync products: ${e.toString()}',
      );
    }
  }
}
