import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

/// Implementation of ProductLocalDataSource using SharedPreferences
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  static const String _cacheKey = 'cached_products';

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonList = products.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await sharedPreferences.setString(_cacheKey, jsonString);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(_cacheKey);
    if (jsonString == null) {
      throw Exception('No cached products found');
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final cached = await getCachedProducts();
    final index = cached.indexWhere((p) => p.id == product.id);
    final updated = List<ProductModel>.from(cached);
    if (index != -1) {
      updated[index] = product;
    } else {
      updated.add(product);
    }
    await cacheProducts(updated);
  }

  @override
  Future<void> removeCachedProduct(String id) async {
    final cached = await getCachedProducts();
    final updated = cached.where((p) => p.id != id).toList();
    await cacheProducts(updated);
  }

  @override
  Future<bool> hasCachedData() async {
    return sharedPreferences.containsKey(_cacheKey);
  }
}