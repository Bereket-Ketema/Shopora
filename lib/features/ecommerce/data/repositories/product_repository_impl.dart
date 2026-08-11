import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';
import '../../../../core/network/network_info.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      if (await networkInfo.isConnected) {
        // Online: Get from remote and cache
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } else {
        // Offline: Get from local cache
        return await _getCachedProducts();
      }
    } catch (e) {
      // If remote fails, try cache
      return await _getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      if (await networkInfo.isConnected) {
        // Online: Get from remote
        final product = await remoteDataSource.getProductById(id);
        if (product != null) {
          await localDataSource.cacheProduct(product);
        }
        return product;
      } else {
        // Offline: Get from local cache
        return await _getCachedProductById(id);
      }
    } catch (e) {
      // Fallback to local
      return await _getCachedProductById(id);
    }
  }

  @override
  Future<Product> insertProduct(Product product) async {
    final productModel = ProductModel.fromProduct(product);

    try {
      if (await networkInfo.isConnected) {
        // Online: Save to remote and cache
        final created = await remoteDataSource.createProduct(productModel);
        await localDataSource.cacheProduct(created);
        return created;
      } else {
        // Offline: Save locally with pending sync
        await localDataSource.cacheProduct(productModel);
        throw Exception('Product saved offline. Will sync when online.');
      }
    } catch (e) {
      // If remote fails, save locally
      await localDataSource.cacheProduct(productModel);
      throw Exception('Product saved locally. Sync will happen when online.');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final productModel = ProductModel.fromProduct(product);

    try {
      if (await networkInfo.isConnected) {
        // Online: Update remote and cache
        final updated = await remoteDataSource.updateProduct(productModel);
        await localDataSource.cacheProduct(updated);
        return updated;
      } else {
        // Offline: Update locally
        await localDataSource.cacheProduct(productModel);
        throw Exception('Product updated offline. Will sync when online.');
      }
    } catch (e) {
      // If remote fails, update locally
      await localDataSource.cacheProduct(productModel);
      throw Exception('Product updated locally. Sync will happen when online.');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      if (await networkInfo.isConnected) {
        // Online: Delete from remote and cache
        await remoteDataSource.deleteProduct(id);
        await localDataSource.removeCachedProduct(id);
      } else {
        // Offline: Delete locally
        await localDataSource.removeCachedProduct(id);
        throw Exception('Product deleted offline. Will sync when online.');
      }
    } catch (e) {
      // If remote fails, delete locally
      await localDataSource.removeCachedProduct(id);
      throw Exception('Product deleted locally. Sync will happen when online.');
    }
  }

  // Private helper methods
  Future<List<Product>> _getCachedProducts() async {
    final cached = await localDataSource.getCachedProducts();
    if (cached.isEmpty) {
      throw Exception('No cached products available. Please connect to the internet.');
    }
    return cached;
  }

  Future<Product?> _getCachedProductById(String id) async {
    final cached = await localDataSource.getCachedProducts();
    try {
      return cached.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}