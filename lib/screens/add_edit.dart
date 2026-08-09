import 'package:flutter/material.dart';
import '../models/product.dart';

class AddEdit extends StatefulWidget {
  const AddEdit({super.key});

  @override
  State<AddEdit> createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  bool isEditing = false;
  Product? editingProduct;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get the product passed from the previous screen
    final Product? product = ModalRoute.of(context)?.settings.arguments as Product?;
    
    if (product != null && !isEditing) {
      isEditing = true;
      editingProduct = product;
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
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
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
            Row(
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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

  void _saveProduct() {
    // Get text from controllers
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String priceText = _priceController.text.trim();
    
    // Validate
    if (title.isEmpty || description.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    
    double price = double.tryParse(priceText) ?? 0.0;
    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }
    
    // ✅ Check if editing or adding
    if (isEditing && editingProduct != null) {
      // EDITING: Return updated product (keep the same ID)
      Product updatedProduct = Product(
        id: editingProduct!.id,
        title: title,
        description: description,
        price: price,
      );
      Navigator.pop(context, updatedProduct);
    } else {
      // ADDING: Create new product
      Product newProduct = Product.create(
        title: title,
        description: description,
        price: price,
      );
      Navigator.pop(context, newProduct);
    }
  }
}