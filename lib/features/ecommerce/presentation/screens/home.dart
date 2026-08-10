import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/view_all_products_usecase.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../../../core/usecases/usecase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = ProductRepositoryImpl();
  late final ViewAllProductsUsecase _viewAllProductsUsecase;

  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewAllProductsUsecase = ViewAllProductsUsecase(_repository);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    _products = await _viewAllProductsUsecase(const NoParams());
    setState(() => _isLoading = false);
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
                      title: Text(product.name),
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
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: product,
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}