// lib/model/briyani_model.dart
import 'package:deliveryapp/model/fooditem.dart';

class BriyaniModel extends FoodItem {
  // Add any Biryani-specific properties here if needed
  // final bool isSpicy;

  BriyaniModel({
    required String image,
    required String name,
    required String price,
    // this.isSpicy = false,
  }) : super(image: image, name: name, price: price, category: 'briyani');
}
