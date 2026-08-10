class Product {
  final String id;
  final String name;        // ✅ Use 'name'
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,      // ✅ Use 'name'
    required this.description,
    required this.price,
    this.imageUrl = '',
  });

  factory Product.create({
    required String name,    // ✅ Use 'name'
    required String description,
    double price = 0.0,
    String imageUrl = '',
  }) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );
  }

  Product copyWith({
    String? name,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}