import 'package:flutter/material.dart';
import '../domain/entities/product.dart';
import '../domain/usecases/view_all_products_usecase.dart';
import '../domain/usecases/delete_product_usecase.dart';
import '../domain/usecases/usecase.dart';  // ✅ Import for NoParams
import '../data/repositories/product_repository_impl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Initialize repository and use cases
  final _repository = ProductRepositoryImpl();
  late final ViewAllProductsUsecase _viewAllProductsUsecase;
  late final DeleteProductUsecase _deleteProductUsecase;
  
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewAllProductsUsecase = ViewAllProductsUsecase(_repository);
    _deleteProductUsecase = DeleteProductUsecase(_repository);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    _products = await _viewAllProductsUsecase(const NoParams());  // ✅ Use const
    setState(() => _isLoading = false);
  }

  Future<void> _deleteProduct(String id) async {
    await _deleteProductUsecase(id);
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products (${_products.length})'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('No products available'))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      title: Text(product.title),
                      leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                      subtitle: Text(product.description),
                      trailing: Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      onTap: () {
                        _navigateToDetail(product);
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEdit,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToAddEdit() async {
    final result = await Navigator.pushNamed(
      context,
      '/add-edit',
      arguments: null,
    );

    if (result == true) {
      await _loadProducts();
    }
  }

  Future<void> _navigateToDetail(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: product,
    );

    if (result == true || result == 'delete') {
      await _loadProducts();
    }
  }
}