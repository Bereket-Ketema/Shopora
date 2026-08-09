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