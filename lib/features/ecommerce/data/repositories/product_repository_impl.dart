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
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (e) {
        return await localDataSource.getCachedProducts();
      }
    } else {
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductById(id);
        if (product != null) {
          await localDataSource.cacheProduct(product);
        }
        return product;
      } catch (e) {
        return await _getCachedProductById(id);
      }
    } else {
      return await _getCachedProductById(id);
    }
  }

  @override
  Future<Product> insertProduct(Product product) async {
    final productModel = ProductModel.fromProduct(product);

    if (await networkInfo.isConnected) {
      try {
        final created = await remoteDataSource.createProduct(productModel);
        await localDataSource.cacheProduct(created);
        return created;
      } catch (e) {
        await localDataSource.cacheProduct(productModel);
        throw Exception('Product saved locally. Sync will happen when online.');
      }
    } else {
      await localDataSource.cacheProduct(productModel);
      throw Exception('Product saved offline. Will sync when online.');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final productModel = ProductModel.fromProduct(product);

    if (await networkInfo.isConnected) {
      try {
        final updated = await remoteDataSource.updateProduct(productModel);
        await localDataSource.cacheProduct(updated);
        return updated;
      } catch (e) {
        await localDataSource.cacheProduct(productModel);
        throw Exception('Product updated locally. Sync will happen when online.');
      }
    } else {
      await localDataSource.cacheProduct(productModel);
      throw Exception('Product updated offline. Will sync when online.');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
        await localDataSource.removeCachedProduct(id);
      } catch (e) {
        await localDataSource.removeCachedProduct(id);
        throw Exception('Product deleted locally. Sync will happen when online.');
      }
    } else {
      await localDataSource.removeCachedProduct(id);
      throw Exception('Product deleted offline. Will sync when online.');
    }
  }

  Future<Product?> _getCachedProductById(String id) async {
    try {
      final cached = await localDataSource.getCachedProducts();
      return cached.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}