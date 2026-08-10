import 'package:flutter/material.dart';
import '../domain/entities/product.dart';
import '../domain/usecases/create_product_usecase.dart';
import '../domain/usecases/update_product_usecase.dart';
import '../data/repositories/product_repository_impl.dart';  // ✅ If you need NoParams

class AddEdit extends StatefulWidget {
  const AddEdit({super.key});

  @override
  State<AddEdit> createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  final _repository = ProductRepositoryImpl();
  late final CreateProductUsecase _createProductUsecase;
  late final UpdateProductUsecase _updateProductUsecase;
  
  bool _isEditing = false;
  Product? _editingProduct;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _createProductUsecase = CreateProductUsecase(_repository);
    _updateProductUsecase = UpdateProductUsecase(_repository);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final Product? product = ModalRoute.of(context)?.settings.arguments as Product?;
    
    if (product != null && !_isEditing) {
      _isEditing = true;
      _editingProduct = product;
      _titleController.text = product.title;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Product Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Product Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          child: const Text('Save'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, false), // ✅ Return false for cancel
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    // Validate
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String priceText = _priceController.text.trim();
    
    if (title.isEmpty || description.isEmpty || priceText.isEmpty) {
      _showError('Please fill all fields');
      return;
    }
    
    double price = double.tryParse(priceText) ?? 0.0;
    if (price <= 0) {
      _showError('Please enter a valid price');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditing && _editingProduct != null) {
        // ✅ EDITING: Update existing product
        final updatedProduct = _editingProduct!.copyWith(
          title: title,
          description: description,
          price: price,
        );
        await _updateProductUsecase(updatedProduct);
        // ✅ Return true to indicate success
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        // ✅ ADDING: Create new product
        final newProduct = Product.create(
          title: title,
          description: description,
          price: price,
        );
        await _createProductUsecase(newProduct);
        // ✅ Return true to indicate success
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      _showError('Failed to save product');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}