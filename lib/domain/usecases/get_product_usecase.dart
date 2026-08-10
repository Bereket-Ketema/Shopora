import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

/// Use case to get a single product by ID
class GetProductUsecase implements UseCase<Product?, String> {
  final ProductRepository repository;

  GetProductUsecase(this.repository);

  @override
  Future<Product?> call(String id) async {
    return await repository.getProductById(id);
  }
}