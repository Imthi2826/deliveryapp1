import 'package:flutter/material.dart';


class Foodtile extends StatefulWidget {
  const Foodtile(String? name, String? image, String? price, {super.key});

  @override
  State<Foodtile> createState() => _FoodtileState();
}

class _FoodtileState extends State<Foodtile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10,left: 10),
      child:Column(
        children: [
          Image.asset("assets/pizza.jpg",
          height: 100,
            width: 100,
            fit: BoxFit.cover,

          )
        ],
      ),
    );
  }
}
