import 'dart:convert';

class ProductResponseModel {
    final String message;
    final List<Product> product;

    ProductResponseModel({
        required this.message,
        required this.product,
    });

    ProductResponseModel copyWith({
        String? message,
        List<Product>? product,
    }) =>
        ProductResponseModel(
            message: message ?? this.message,
            product: product ?? this.product,
        );

    factory ProductResponseModel.fromJson(String str) => ProductResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductResponseModel.fromMap(Map<String, dynamic> json) => ProductResponseModel(
        message: json["message"],
        product: List<Product>.from(json["product"].map((x) => Product.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "product": List<dynamic>.from(product.map((x) => x.toMap())),
    };
}

class Product {
    final int id;
    final String name;
    final String description;
    final String price;
    final String category;
    final String imageUrl;
    final DateTime createdAt;
    final DateTime updatedAt;

    Product({
        required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.category,
        required this.imageUrl,
        required this.createdAt,
        required this.updatedAt,
    });

    Product copyWith({
        int? id,
        String? name,
        String? description,
        String? price,
        String? category,
        String? imageUrl,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) =>
        Product(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            price: price ?? this.price,
            category: category ?? this.category,
            imageUrl: imageUrl ?? this.imageUrl,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        category: json["category"],
        imageUrl: json["image_url"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "category": category,
        "image_url": imageUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}