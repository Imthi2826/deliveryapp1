// lib/model/food_item.dart
abstract class FoodItem {
  String get image; // Assuming image is always a non-nullable String asset path
  String get name;  // Assuming name is always a non-nullable String
  String get price; // Assuming price is a String like "10.99"
// Add any other common properties if needed
}