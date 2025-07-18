import 'package:deliveryapp/model/fooditem.dart';
import 'package:deliveryapp/model/briyani_model.dart';

List<FoodItem> getbriyani() {
  return [
    BriyaniModel(
      name: "Classic Beef Biryani",
      image: "assets/b1.jpg",
      price: "180",
    ),
    BriyaniModel(
      name: "Spicy Chicken Biryani",
      image: "assets/b2.jpg",
      price: "220",
    ),
    BriyaniModel(
      name: "Mutton Biryani",
      image: "assets/b3.jpg",
      price: "160",
    ),
    BriyaniModel(
      name: "Double Beef Biryani",
      image: "assets/b4.jpg",
      price: "280",
    ),
  ];
}
