
import 'package:deliveryapp/model/fooditem.dart'; // Import the interface

class BriyaniModel implements FoodItem {
  @override
  final String image;
  @override
  final String name;
  @override
  final String price;
  // Add any other burger-specific fields here
  // e.g., final bool isVeg;

  BriyaniModel({
    required this.image,
    required this.name,
    required this.price,
    // required this.isVeg,
  });

// If you have factory constructors for dummy data, they can remain
// static BurgerModel fromJson(Map<String, dynamic> json) { ... }
}