class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double ratingRate;
  final int ratingCount;
  bool favorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.ratingRate,
    required this.ratingCount,
    this.favorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json["rating"] as Map<String, dynamic>? ?? {};
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: (json["price"] as num).toDouble(),
      image: json["image"],
      description: json["description"] ?? '',
      category: json["category"] ?? '',
      ratingRate: (rating["rate"] as num?)?.toDouble() ?? 0.0,
      ratingCount: (rating["count"] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "image": image,
      "description": description,
      "category": category,
      "rating": {"rate": ratingRate, "count": ratingCount},
    };
  }
}
