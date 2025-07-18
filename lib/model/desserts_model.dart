import 'package:deliveryapp/model/fooditem.dart';

class DessertsModel implements FoodItem {
  @override
  final String image;
  @override
  final String name;
  @override
  final String price;
  @override
  final String category = 'desserts';

  DessertsModel({
    required this.image,
    required this.name,
    required this.price,
  });
}
