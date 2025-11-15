import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
    int? offset,
    int? limit,
  });

  Future<ProductModel> getProductById(String id);

  Future<ProductModel> createProduct(Map<String, dynamic> productData);

  Future<ProductModel> updateProduct(
      String id, Map<String, dynamic> productData);

  Future<void> deleteProduct(String id);

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
      final queryParams = <String, String>{};

      if (name != null) queryParams['name'] = name;
      if (category != null) queryParams['category'] = category;
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
      if (supplierId != null) queryParams['supplierId'] = supplierId;
      if (offset != null) queryParams['offset'] = offset.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final response = await apiClient.get(
        AppConstants.productsEndpoint,
        queryParameters: queryParams,
        requiresAuth: false,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      // A resposta pode vir com a estrutura { products: [], total: 0 } ou diretamente como array
      final List<dynamic> productsData;
      if (response is Map<String, dynamic> &&
          response.containsKey('products')) {
        productsData = response['products'] as List<dynamic>;
      } else if (response is List) {
        productsData = response;
      } else {
        throw ServerException(message: 'Unexpected response format');
      }

      return productsData
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
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
      if (e is NotFoundException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to get product: ${e.toString()}',
      );
    }
  }

  @override
  Future<ProductModel> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await apiClient.post(
        AppConstants.productsEndpoint,
        body: productData,
        requiresAuth: true,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      return ProductModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to create product: ${e.toString()}',
      );
    }
  }

  @override
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final response = await apiClient.patch(
        '${AppConstants.productsEndpoint}/$id',
        body: productData,
        requiresAuth: true,
      );

      if (response == null) {
        throw ServerException(message: 'Invalid response from server');
      }

      return ProductModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
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
      if (e is ServerException) {
        rethrow;
      }
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
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to sync products: ${e.toString()}',
      );
    }
  }
}
