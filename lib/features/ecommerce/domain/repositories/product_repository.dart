import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product?> getProductById(String id);
  Future<Product> insertProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}