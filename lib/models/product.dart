class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      imageUrl: json['image_url'],
      category: json['category'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              price == other.price &&
              imageUrl == other.imageUrl &&
              category == other.category;

  @override
  int get hashCode =>
      name.hashCode ^ price.hashCode ^ imageUrl.hashCode ^ category.hashCode;
}