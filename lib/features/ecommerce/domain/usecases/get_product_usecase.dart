import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUsecase implements UseCase<Product?, String> {
  final ProductRepository repository;

  GetProductUsecase(this.repository);

  @override
  Future<Product?> call(String id) async {
    return await repository.getProductById(id);
  }
}
