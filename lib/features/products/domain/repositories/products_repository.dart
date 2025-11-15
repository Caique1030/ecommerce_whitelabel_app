import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

/// Repositório abstrato para operações de produtos
abstract class ProductsRepository {
  /// Obtém a lista de produtos com filtros opcionais
  ///
  /// Parâmetros:
  /// - [name]: Nome do produto para busca
  /// - [category]: Categoria do produto
  /// - [minPrice]: Preço mínimo
  /// - [maxPrice]: Preço máximo
  /// - [supplierId]: ID do fornecedor
  /// - [offset]: Offset para paginação
  /// - [limit]: Limite de resultados
  ///
  /// Retorna [Right(List<Product>)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, List<Product>>> getProducts({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? supplierId,
    int? offset,
    int? limit,
  });

  /// Obtém um produto específico por ID
  ///
  /// Retorna [Right(Product)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, Product>> getProductById(String id);

  /// Cria um novo produto
  ///
  /// Retorna [Right(Product)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, Product>> createProduct(Product product);

  /// Atualiza um produto existente
  ///
  /// Retorna [Right(Product)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, Product>> updateProduct(String id, Product product);

  /// Remove um produto
  ///
  /// Retorna [Right(void)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, void>> deleteProduct(String id);

  /// Sincroniza produtos dos fornecedores
  ///
  /// Retorna [Right(void)] em caso de sucesso
  /// Retorna [Left(Failure)] em caso de erro
  Future<Either<Failure, void>> syncProducts();
}
