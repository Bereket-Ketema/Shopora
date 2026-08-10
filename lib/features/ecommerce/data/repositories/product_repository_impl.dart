import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

/// Implementation of ProductRepository with data source dependencies
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      // Try to get from remote
      final remoteProducts = await remoteDataSource.getAllProducts();
      // Cache the results locally
      await localDataSource.cacheProducts(remoteProducts);
      return remoteProducts;
    } catch (e) {
      // If remote fails, get from local cache
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        return cachedProducts;
      } catch (_) {
        // If no cache, throw exception
        rethrow;
      }
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      // Try remote first
      final product = await remoteDataSource.getProductById(id);
      if (product != null) {
        await localDataSource.cacheProduct(product);
      }
      return product;
    } catch (e) {
      // Fallback to local
      try {
        final cached = await localDataSource.getCachedProducts();
        return cached.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<Product> insertProduct(Product product) async {
    // Convert entity to model
    final productModel = ProductModel.fromProduct(product);
    // Save to remote
    final created = await remoteDataSource.createProduct(productModel);
    // Update cache
    await localDataSource.cacheProduct(created);
    return created;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    // Convert entity to model
    final productModel = ProductModel.fromProduct(product);
    // Update remote
    final updated = await remoteDataSource.updateProduct(productModel);
    // Update cache
    await localDataSource.cacheProduct(updated);
    return updated;
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Delete from remote
    await remoteDataSource.deleteProduct(id);
    // Remove from cache
    await localDataSource.removeCachedProduct(id);
  }
}