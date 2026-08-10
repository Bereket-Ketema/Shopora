import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product?> getProductById(String id);
  Future<Product> createProduct(Product product);   // ✅ Add this
  Future<Product> insertProduct(Product product);   // ✅ Keep this too
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}