// lib/model/pizza_model.dart
import 'package:deliveryapp/model/fooditem.dart'; // Import the interface

class PizzaModel implements FoodItem {
  @override
  final String image;
  @override
  final String name;
  @override
  final String price;
  // Add any other pizza-specific fields here
  // e.g., final List<String> toppings;

  PizzaModel({
    required this.image,
    required this.name,
    required this.price,
    // required this.toppings,
  });

// If you have factory constructors for dummy data, they can remain
// static PizzaModel fromJson(Map<String, dynamic> json) { ... }
}
