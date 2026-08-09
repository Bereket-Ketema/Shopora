import 'package:flutter/material.dart';
import '../models/product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [
    Product(
      id: '1',
      title: 'Laptop',
      description: 'High-performance laptop with 16GB RAM and 512GB SSD',
      price: 999.99,
    ),
    Product(
      id: '2',
      title: 'Wireless Headphones',
      description: 'Noise-canceling headphones with 30-hour battery life',
      price: 199.99,
    ),
    Product(
      id: '3',
      title: 'Smartphone',
      description: '6.5-inch display with 128GB storage and 5G support',
      price: 699.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products (${products.length})'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var item = products[index];

          return ListTile(
            title: Text(item.title),
            leading: const Icon(Icons.shopping_bag, color: Colors.blue),
            subtitle: Text(item.description),
            trailing: Text(
              '\$${item.price}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            onTap: () {
              // ✅ Navigate to Detail and wait for result
              _navigateToDetail(item);
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

    if (result is Product) {
      setState(() {
        products.add(result);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.title} added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _navigateToDetail(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: product,
    );

    // ✅ Handle result from Detail screen
    if (result is Product) {
      // Product was updated
      final index = products.indexWhere((p) => p.id == result.id);
      if (index != -1) {
        setState(() {
          products[index] = result;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.title} updated successfully!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } else if (result == 'delete') {
      // Product was deleted
      setState(() {
        products.removeWhere((p) => p.id == product.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.title} deleted successfully!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}