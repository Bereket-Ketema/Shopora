import '../repositories/product_repository.dart';
import 'usecase.dart';

/// Use case to delete a product by ID
class DeleteProductUsecase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw Exception('Product ID cannot be empty');
    }
    await repository.deleteProduct(id);
  }
}