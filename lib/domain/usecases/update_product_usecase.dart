import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

/// Use case to update an existing product
class UpdateProductUsecase implements UseCase<Product, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<Product> call(Product product) async {
    return await repository.updateProduct(product);
  }
}