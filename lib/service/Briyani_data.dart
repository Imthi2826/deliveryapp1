
import 'package:deliveryapp/model/fooditem.dart'; // Import FoodItem
import 'package:deliveryapp/model/briyani_model.dart';

// Option 1: Returning List<FoodItem> (Recommended for consistency with Homepage)
List<FoodItem> getbriyani() {
  List<FoodItem> briyani = []; // Use 'briyani' as the list name for clarity

  // Burger 1
  briyani.add(BriyaniModel(
    name: "Classic Beef biryani",
    image: "assets/b1.jpg", // Use actual burger asset paths
    price: "180",
    // Add any other burger-specific properties if your BurgerModel has them
    // e.g., isVeg: false,
  ));

  // Burger 2
  briyani.add(BriyaniModel(
    name: "Spicy Chicken biryani",
    image: "assets/b2.jpg",
    price: "220",
  ));

  // Burger 3
  briyani.add(BriyaniModel(
    name: "Mutton Biryani",
    image: "assets/b3.jpg",
    price: "160",
    // isVeg: true,
  ));

  // Burger 4
  briyani.add(BriyaniModel(
    name: "Double Beef biryani",
    image: "assets/b4.jpg",
    price: "280",
  ));
  briyani.add(BriyaniModel(
    name: "Double Beef biryani",
    image: "assets/b4.jpg",
    price: "280",
  ));

  // Add more burger items as needed...

  return briyani;
}