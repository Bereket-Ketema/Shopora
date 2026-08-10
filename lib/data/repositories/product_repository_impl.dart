import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

/// Implementation of ProductRepository
class ProductRepositoryImpl implements ProductRepository {
  // In-memory storage (replace with database later)
  List<Product> _products = [];

  @override
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    _products.add(product);
    return product;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}