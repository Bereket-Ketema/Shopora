class Product {
  final String id;
  String title;
  String description;
  double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory Product.create({
    required String title,
    required String description,
    required double price,
  }) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      price: price,
    );
  }

  // Copy with method for editing
  Product copyWith({
    String? title,
    String? description,
    double? price,
  }) {
    return Product(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}