import '../models/product_model.dart';
import 'product_remote_data_source.dart';

/// Implementation of ProductRemoteDataSource (In-memory for now)
/// Later, this can be replaced with actual API calls
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  // In-memory storage (simulating a remote database)
  final List<ProductModel> _products = [];

  // Sample data on initialization
  ProductRemoteDataSourceImpl() {
    _initSampleData();
  }

  void _initSampleData() {
    if (_products.isEmpty) {
      _products.addAll([
        ProductModel(
          id: '1',
          name: 'Laptop',
          description: 'High-performance laptop with 16GB RAM and 512GB SSD',
          price: 999.99,
          imageUrl: 'https://example.com/laptop.jpg',
        ),
        ProductModel(
          id: '2',
          name: 'Wireless Headphones',
          description: 'Noise-canceling headphones with 30-hour battery life',
          price: 199.99,
          imageUrl: 'https://example.com/headphones.jpg',
        ),
        ProductModel(
          id: '3',
          name: 'Smartphone',
          description: '6.5-inch display with 128GB storage and 5G support',
          price: 699.99,
          imageUrl: 'https://example.com/smartphone.jpg',
        ),
      ]);
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_products);
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _products.add(product);
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      return _products[index];
    }
    throw Exception('Product with ID ${product.id} not found');
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final initialLength = _products.length;
    _products.removeWhere((p) => p.id == id);
    if (_products.length == initialLength) {
      throw Exception('Product with ID $id not found');
    }
  }
}
