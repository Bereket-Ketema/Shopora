import 'package:flutter/material.dart';
import '../domain/entities/product.dart';
import '../domain/usecases/delete_product_usecase.dart';
import '../data/repositories/product_repository_impl.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Product _product;
  final _repository = ProductRepositoryImpl();
  late final DeleteProductUsecase _deleteProductUsecase;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _deleteProductUsecase = DeleteProductUsecase(_repository);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _product = ModalRoute.of(context)?.settings.arguments as Product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
        actions: [
          IconButton(
            onPressed: _navigateToEdit,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _product.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '\$${_product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _deleteProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Delete Product'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.pushNamed(
      context,
      '/add-edit',
      arguments: _product,
    );

    if (result == true) {
      // Product was updated, refresh the detail screen
      final updatedProduct = await _repository.getProductById(_product.id);
      if (updatedProduct != null) {
        setState(() => _product = updatedProduct);
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _deleteProduct() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${_product.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                await _deleteProductUsecase(_product.id);
                if (mounted) {
                  setState(() => _isLoading = false);
                  Navigator.pop(context, 'delete');
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}