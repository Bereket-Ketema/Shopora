import '../models/product_model.dart';

/// Contract for remote data operations
abstract class ProductRemoteDataSource {
  /// Get all products from remote source
  Future<List<ProductModel>> getAllProducts();

  /// Get a single product by ID
  Future<ProductModel?> getProductById(String id);

  /// Create a new product on remote source
  Future<ProductModel> createProduct(ProductModel product);

  /// Update a product on remote source
  Future<ProductModel> updateProduct(ProductModel product);

  /// Delete a product from remote source
  Future<void> deleteProduct(String id);
}