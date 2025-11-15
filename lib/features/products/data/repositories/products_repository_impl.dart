import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/features/products/data/datasources/product_remote_datasources.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
    int? offset,
    int? limit,
  }) async {
    try {
      final productModels = await remoteDataSource.getProducts(
        name: name,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        supplierId: supplierId,
        offset: offset,
        limit: limit,
      );

      final products = productModels.map((model) => model as Product).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnexpectedFailure('Erro inesperado ao buscar produtos'),
      );
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final productModel = await remoteDataSource.getProductById(id);
      return Right(productModel);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnexpectedFailure('Erro inesperado ao buscar produto'),
      );
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final createdProduct = await remoteDataSource.createProduct(
        productModel.toJson(),
      );
      return Right(createdProduct);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnexpectedFailure('Erro inesperado ao criar produto'),
      );
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(
    String id,
    Product product,
  ) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final updatedProduct = await remoteDataSource.updateProduct(
        id,
        productModel.toJson(),
      );
      return Right(updatedProduct);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnexpectedFailure('Erro inesperado ao atualizar produto'),
      );
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
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnexpectedFailure('Erro inesperado ao deletar produto'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> syncProducts() async {
    try {
      await remoteDataSource.syncProducts();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        UnexpectedFailure('Erro inesperado ao sincronizar produtos'),
      );
    }
  }
}
