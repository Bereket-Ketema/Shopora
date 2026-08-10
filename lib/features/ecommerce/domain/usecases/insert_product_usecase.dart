import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class InsertProductUsecase implements UseCase<Product, Product> {
  final ProductRepository repository;

  InsertProductUsecase(this.repository);

  @override
  Future<Product> call(Product product) async {
    if (product.name.isEmpty) {
      throw Exception('Product name cannot be empty');
    }
    if (product.price <= 0) {
      throw Exception('Price must be greater than zero');
    }
    return await repository.insertProduct(product);
  }
}