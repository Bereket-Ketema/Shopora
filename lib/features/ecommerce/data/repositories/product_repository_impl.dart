import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  // In-memory storage using ProductModel
  final List<ProductModel> _products = [];

  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_products);
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Product> insertProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final productModel = ProductModel.fromProduct(product);
    _products.add(productModel);
    return productModel;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = ProductModel.fromProduct(product);
      return _products[index];
    }
    throw Exception('Product with ID ${product.id} not found');
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // ✅ Fixed: Check if product exists before removing
    final exists = _products.any((p) => p.id == id);
    if (!exists) {
      throw Exception('Product with ID $id not found');
    }
    
    // ✅ Fixed: Remove without assigning to a variable
    _products.removeWhere((p) => p.id == id);
  }
}