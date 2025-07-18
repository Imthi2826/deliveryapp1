import 'package:deliveryapp/model/fooditem.dart';

class PizzaModel implements FoodItem {
  @override
  final String image;

  @override
  final String name;

  @override
  final String price;

  @override
  final String category = 'pizza';

  PizzaModel({
    required this.image,
    required this.name,
    required this.price,
  });
}
