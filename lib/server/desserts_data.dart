import 'package:deliveryapp/model/desserts_model.dart';
import 'package:deliveryapp/model/fooditem.dart';

List<FoodItem> getdessert() {
  List<FoodItem> desserts = [];
desserts.add(DessertsModel(
  image: "assets/dd12.jpg",
  name: "Delicious desserts",
  price: "80",

));

  desserts.add(DessertsModel(
    image: "assets/dd11.jpg",
    name: "desserts cake",
    price: "100",

  ));
  desserts.add(DessertsModel(
    image: "assets/ad11.jpg",
    name: "Angle cake",
    price: "100",

  ));
  desserts.add(DessertsModel(
    image: "assets/vad.jpg",
    name: "Angle happy cake",
    price: "100",

  ));
return desserts;
}

