import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

/// Use case to create a new product
class CreateProductUsecase implements UseCase<Product, Product> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<Product> call(Product product) async {
    return await repository.createProduct(product);
  }
}