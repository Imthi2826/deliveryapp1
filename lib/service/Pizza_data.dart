
import 'package:deliveryapp/model/pizza_model.dart';
import 'package:deliveryapp/model/fooditem.dart'; // Import FoodItem

List<FoodItem> getpizza() { // Return type is List<FoodItem>
  List<FoodItem> pizza = [];
  PizzaModel pizzaModel = PizzaModel(
    image: "assets/pizza11.jpg", // Ensure asset paths are correct
    name: "Pepperoni Classic",
    price: "250",
  );
  pizza.add(pizzaModel);

  pizzaModel = PizzaModel(
    image: "assets/pizza12.jpg",
    name: "Margherita Dream",
    price: "220",
  );
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel(
    image: "assets/pizza13.jpg",
    name: "Italian pizza",
    price: "220",
  );
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel(
    image: "assets/delicious-pizza-studio.jpg",
    name: "cheese pizza",
    price: "220",
  );
  pizza.add(pizzaModel);

  // Add more pizza items
  return pizza;
}
