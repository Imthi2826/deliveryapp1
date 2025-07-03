import 'package:deliveryapp/model/category_model.dart';
import 'package:deliveryapp/model/category_tile.dart';
import 'package:deliveryapp/model/pizza_model.dart';
import 'package:deliveryapp/model/pizza_tile.dart';
import 'package:deliveryapp/service/Pizza_data.dart';
import 'package:deliveryapp/service/category_data.dart';
import 'package:deliveryapp/service/widget_size.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<CategoryModel> categories = [];
  List<PizzaModel> pizza=[];
  String selectedCategoryIndex = "0";

  // 👈 tracking selection

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    pizza = getpizza();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Foo", style: AppWidget.threelineTextFieldStyle()),
                      TextSpan(text: "D", style: AppWidget.twolineTextFieldStyle()),
                      TextSpan(text: "ev", style: AppWidget.onelineTextFieldStyle()),
                    ],
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/profile.jpeg",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              "Order your favorite food!",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),

            const SizedBox(height: 20),

            // Search bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 50,
                   width: 50,
                  decoration: BoxDecoration(
                    color: Color(0xfff84c6b),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Horizontal Category List
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index.toString(); //selecting value
                      });
                    },
                    child: CategoryTile(
                      name: categories[index].name!,
                      image: categories[index].image!,
                      categoryIndex: index.toString(),
                      selectedIndex: selectedCategoryIndex,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 05,),
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:2,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 10.0,

                  ),
              itemCount: pizza.length,
                itemBuilder: (context,index){
                    return Foodtile(
                      pizza[index].name,
                    pizza[index].image,
                      pizza[index].price,
                    );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
