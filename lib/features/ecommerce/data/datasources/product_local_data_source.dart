import '../models/product_model.dart';

/// Contract for local data operations
abstract class ProductLocalDataSource {
  /// Cache a list of products locally
  Future<void> cacheProducts(List<ProductModel> products);

  /// Get cached products
  Future<List<ProductModel>> getCachedProducts();

  /// Cache a single product
  Future<void> cacheProduct(ProductModel product);

  /// Remove a product from cache
  Future<void> removeCachedProduct(String id);

  /// Check if cache exists
  Future<bool> hasCachedData();

  /// Clear all cached data
  Future<void> clearCache();

  /// Get pending sync items (products that need to be synced)
  Future<List<ProductModel>> getPendingSyncItems();

  /// Mark an item as synced
  Future<void> markAsSynced(String id);
}