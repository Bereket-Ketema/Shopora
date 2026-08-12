import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

/// Implementation of ProductLocalDataSource using SharedPreferences
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  // Keys for SharedPreferences storage
  static const String _cacheKey = 'cached_products';
  static const String _pendingSyncKey = 'pending_sync';

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final jsonList = products.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await sharedPreferences.setString(_cacheKey, jsonString);
    } catch (e) {
      throw Exception('Failed to cache products: $e');
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final jsonString = sharedPreferences.getString(_cacheKey);
      if (jsonString == null) {
        throw Exception('No cached products found');
      }
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get cached products: $e');
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      List<ProductModel> cachedProducts;
      try {
        cachedProducts = await getCachedProducts();
      } catch (e) {
        cachedProducts = [];
      }

      final index = cachedProducts.indexWhere((p) => p.id == product.id);
      final updated = List<ProductModel>.from(cachedProducts);

      if (index != -1) {
        updated[index] = product;
      } else {
        updated.add(product);
      }

      await cacheProducts(updated);
    } catch (e) {
      throw Exception('Failed to cache product: $e');
    }
  }

  @override
  Future<void> removeCachedProduct(String id) async {
    try {
      final cached = await getCachedProducts();
      final updated = cached.where((p) => p.id != id).toList();
      await cacheProducts(updated);
    } catch (e) {
      // Cache might not exist, ignore
    }
  }

  @override
  Future<bool> hasCachedData() async {
    return sharedPreferences.containsKey(_cacheKey);
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cacheKey);
    await sharedPreferences.remove(_pendingSyncKey);
  }

  @override
  Future<List<ProductModel>> getPendingSyncItems() async {
    try {
      final jsonString = sharedPreferences.getString(_pendingSyncKey);
      if (jsonString == null) {
        return [];
      }
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> markAsSynced(String id) async {
    try {
      final pending = await getPendingSyncItems();
      final updated = pending.where((p) => p.id != id).toList();

      if (updated.isEmpty) {
        await sharedPreferences.remove(_pendingSyncKey);
      } else {
        final jsonList = updated.map((p) => p.toJson()).toList();
        final jsonString = jsonEncode(jsonList);
        await sharedPreferences.setString(_pendingSyncKey, jsonString);
      }
    } catch (e) {
      throw Exception('Failed to mark item as synced: $e');
    }
  }
}