import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/product_remote_datasources.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  static const String _cachedProductsKey = 'CACHED_PRODUCTS';
  static const String _cacheTimestampKey = 'CACHE_TIMESTAMP';
  static const int _cacheValidityHours = 24;

  ProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
    int? offset,
    int? limit,
    bool forceRefresh = false,
  }) async {
    try {
      // ✅ Verifica se tem filtros ativos
      final hasFilters = name != null ||
          category != null ||
          minPrice != null ||
          maxPrice != null ||
          supplierId != null;

      // ✅ Se tem filtros, busca do cache e filtra localmente
      if (hasFilters) {
        final cachedProducts = await _getCachedProducts();

        if (cachedProducts.isNotEmpty) {
          // Aplica filtros localmente
          final filteredProducts = _applyLocalFilters(
            cachedProducts,
            name: name,
            category: category,
            minPrice: minPrice,
            maxPrice: maxPrice,
            supplierId: supplierId,
          );

          return Right(filteredProducts);
        }
      }

      // ✅ Se não tem cache válido ou não tem filtros, busca da API
      if (!hasFilters && await _hasCachedProducts()) {
        final cachedProducts = await _getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return Right(cachedProducts);
        }
      }

      // ✅ Busca da API
      final products = await remoteDataSource.getProducts(
        name: name,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        supplierId: supplierId,
        offset: offset,
        limit: limit,
      );

      // ✅ Salva no cache apenas se não tiver filtros
      if (!hasFilters && products.isNotEmpty) {
        await _cacheProducts(products);
      }

      return Right(products);
    } on ServerException catch (e) {
      // ✅ Erro na API? Tenta retornar cache
      final cachedProducts = await _getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        // Se tem filtros, aplica localmente
        if (name != null ||
            category != null ||
            minPrice != null ||
            maxPrice != null) {
          final filtered = _applyLocalFilters(
            cachedProducts,
            name: name,
            category: category,
            minPrice: minPrice,
            maxPrice: maxPrice,
          );
          return Right(filtered);
        }
        return Right(cachedProducts);
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      final cachedProducts = await _getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        if (name != null ||
            category != null ||
            minPrice != null ||
            maxPrice != null) {
          final filtered = _applyLocalFilters(
            cachedProducts,
            name: name,
            category: category,
            minPrice: minPrice,
            maxPrice: maxPrice,
          );
          return Right(filtered);
        }
        return Right(cachedProducts);
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  /// ✅ NOVO: Aplica filtros localmente nos produtos em cache
  List<Product> _applyLocalFilters(
    List<Product> products, {
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
  }) {
    var filtered = products;

    // Filtro por nome (case insensitive)
    if (name != null && name.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(name.toLowerCase()) ||
            (p.description?.toLowerCase().contains(name.toLowerCase()) ??
                false);
      }).toList();
    }

    // Filtro por categoria (case insensitive e normalizado)
    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((p) {
        if (p.category == null) return false;

        final productCategory = _normalizeCategory(p.category!);
        final searchCategory = _normalizeCategory(category);

        return productCategory == searchCategory ||
            productCategory.contains(searchCategory);
      }).toList();
    }

    // Filtro por preço mínimo
    if (minPrice != null) {
      filtered = filtered.where((p) => p.price >= minPrice).toList();
    }

    // Filtro por preço máximo
    if (maxPrice != null) {
      filtered = filtered.where((p) => p.price <= maxPrice).toList();
    }

    // Filtro por fornecedor
    if (supplierId != null) {
      filtered = filtered.where((p) => p.supplierId == supplierId).toList();
    }

    return filtered;
  }

  /// ✅ NOVO: Normaliza categorias para melhorar as buscas
  String _normalizeCategory(String category) {
    return category
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' '); // Remove espaços extras
  }

  @override
  Future<Either<Failure, void>> syncProducts() async {
    try {
      await _clearCache();
      await remoteDataSource.syncProducts();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  // ✅ Métodos de cache
  Future<List<Product>> _getCachedProducts() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedProductsKey);

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Erro ao ler cache: $e');
      return [];
    }
  }

  Future<void> _cacheProducts(List<Product> products) async {
    try {
      final jsonList =
          products.map((p) => ProductModel.fromEntity(p).toJson()).toList();
      final jsonString = json.encode(jsonList);

      await sharedPreferences.setString(_cachedProductsKey, jsonString);
      await sharedPreferences.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      print('✅ ${products.length} produtos salvos no cache');
    } catch (e) {
      print('❌ Erro ao salvar cache: $e');
    }
  }

  Future<bool> _hasCachedProducts() async {
    final timestamp = sharedPreferences.getInt(_cacheTimestampKey);

    if (timestamp == null) {
      return false;
    }

    final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheDate);

    return difference.inHours < _cacheValidityHours;
  }

  Future<void> _clearCache() async {
    await sharedPreferences.remove(_cachedProductsKey);
    await sharedPreferences.remove(_cacheTimestampKey);
    print('🗑️ Cache limpo');
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final createdProduct = await remoteDataSource.createProduct(productModel);
      return Right(createdProduct);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(
    String id,
    Product product,
  ) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final updatedProduct =
          await remoteDataSource.updateProduct(id, productModel);
      return Right(updatedProduct);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
