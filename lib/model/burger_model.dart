import 'package:deliveryapp/model/fooditem.dart';

class BurgerModel implements FoodItem {
  @override
  final String image;
  @override
  final String name;
  @override
  final String price;
  @override
  final String category = 'burger';

  BurgerModel({
    required this.image,
    required this.name,
    required this.price,
  });
}
