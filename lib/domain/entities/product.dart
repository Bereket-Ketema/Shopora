class Product {
  final String id;
  String title;
  String description;
  String imageUrl;      // ✅ Added new field
  double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',   // Default empty string
    required this.price,
  });

  factory Product.create({
    required String title,
    required String description,
    String imageUrl = '',
    required double price,
  }) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );
  }

  Product copyWith({
    String? title,
    String? description,
    String? imageUrl,
    double? price,
  }) {
    return Product(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }
}