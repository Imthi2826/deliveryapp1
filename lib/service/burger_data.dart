
import 'package:deliveryapp/model/fooditem.dart'; // Import FoodItem
import 'package:deliveryapp/model/burger_model.dart';

// Option 1: Returning List<FoodItem> (Recommended for consistency with Homepage)
List<FoodItem> getburger() {
  List<FoodItem> burgers = []; // Use 'burgers' as the list name for clarity

  // Burger 1
  burgers.add(BurgerModel(
    name: "Classic Beef Burger",
    image: "assets/ccf.jpg", // Use actual burger asset paths
    price: "180",
    // Add any other burger-specific properties if your BurgerModel has them
    // e.g., isVeg: false,
  ));

  // Burger 2
  burgers.add(BurgerModel(
    name: "Spicy Chicken Burger",
    image: "assets/db.jpg",
    price: "220",
  ));

  // Burger 3
  burgers.add(BurgerModel(
    name: "Veggie Supreme Burger",
    image: "assets/burger.jpg",
    price: "160",
    // isVeg: true,
  ));

  // Burger 4
  burgers.add(BurgerModel(
    name: "Double Cheese Blast",
    image: "assets/ddb.jpg",
    price: "280",
  ));

  // Add more burger items as needed...

  return burgers;
}

// Option 2: Returning List<BurgerModel> (If you haven't implemented FoodItem yet for BurgerModel)
/*
List<BurgerModel> getburger() {
  List<BurgerModel> burgers = [];

  // Burger 1
  burgers.add(BurgerModel(
    name: "Classic Beef Burger",
    image: "assets/burgers/burger1.png",
    price: "180",
  ));

  // Burger 2
  burgers.add(BurgerModel(
    name: "Spicy Chicken Burger",
    image: "assets/burgers/burger2.png",
    price: "220",
  ));
  
  // ... and so on
  
  return burgers;
}
*/
