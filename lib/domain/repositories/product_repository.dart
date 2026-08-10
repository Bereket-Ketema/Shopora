import '../entities/product.dart';

/// Interface for product repository
/// Defines the contract for data operations
abstract class ProductRepository {
  /// Get all products
  Future<List<Product>> getAllProducts();
  
  /// Get a specific product by ID
  Future<Product?> getProductById(String id);
  
  /// Create a new product
  Future<Product> createProduct(Product product);
  
  /// Update an existing product
  Future<Product> updateProduct(Product product);
  
  /// Delete a product by ID
  Future<void> deleteProduct(String id);
}