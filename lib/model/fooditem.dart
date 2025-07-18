class FoodItem {
  final String name;
  final String image;
  final String price;
  final String category;

  FoodItem({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });

  factory FoodItem.fromFirestore(Map<String, dynamic> data) {
    return FoodItem(
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
