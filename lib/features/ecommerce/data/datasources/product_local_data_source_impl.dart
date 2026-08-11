import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

/// Implementation of ProductLocalDataSource using SharedPreferences
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  static const String _cacheKey = 'cached_products';
  static const String _pendingSyncKey = 'pending_sync';

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    // ✅ Handle null or empty list
    if (products.isEmpty) {
      await sharedPreferences.remove(_cacheKey);
      return;
    }
    final jsonList = products.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await sharedPreferences.setString(_cacheKey, jsonString);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(_cacheKey);
    if (jsonString == null || jsonString.isEmpty) {
      return []; // ✅ Return empty list instead of throwing
    }
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      return []; // ✅ Return empty list on error
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      final cached = await getCachedProducts();
      final index = cached.indexWhere((p) => p.id == product.id);
      final updated = List<ProductModel>.from(cached);
      if (index != -1) {
        updated[index] = product;
      } else {
        updated.add(product);
      }
      await cacheProducts(updated);
    } catch (e) {
      // If no cache exists, create new one
      await cacheProducts([product]);
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
    final jsonString = sharedPreferences.getString(_cacheKey);
    return jsonString != null && jsonString.isNotEmpty;
  }

  @override
  Future<List<ProductModel>> getPendingSyncItems() async {
    final jsonString = sharedPreferences.getString(_pendingSyncKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> markAsSynced(String id) async {
    final pending = await getPendingSyncItems();
    final updated = pending.where((p) => p.id != id).toList();
    if (updated.isEmpty) {
      await sharedPreferences.remove(_pendingSyncKey);
    } else {
      final jsonList = updated.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await sharedPreferences.setString(_pendingSyncKey, jsonString);
    }
  }
}