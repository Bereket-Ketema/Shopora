import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

/// Use case to get a specific product by ID
class ViewProductUsecase implements UseCase<Product?, String> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Product?> call(String id) async {
    return await repository.getProductById(id);
  }
}