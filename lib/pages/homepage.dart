import 'package:deliveryapp/model/category_model.dart';
import 'package:deliveryapp/model/category_tile.dart';
import 'package:deliveryapp/model/fooditem.dart';
import 'package:deliveryapp/pages/Detail_pages.dart';
import 'package:deliveryapp/pages/bottomnavigation.dart';
import 'package:deliveryapp/service/Pizza_data.dart';
import 'package:deliveryapp/service/burger_data.dart';
import 'package:deliveryapp/service/category_data.dart';
import 'package:deliveryapp/service/desserts_data.dart';
import 'package:deliveryapp/service/widget_size.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> categories = [];
  List<FoodItem> pizza = [];
  List<FoodItem> burger = [];
  List<FoodItem> desserts = [];
  String selectedCategoryIndex = "1";

  void _handleSearch(){
    String place =_searchController.text.trim();
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    pizza = getpizza();
    burger = getburger();
    desserts = getdessert();
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodItem> items;
    if (selectedCategoryIndex == "0") {
      items = pizza;
    } else if (selectedCategoryIndex == "1") {
      items = burger;
    } else if (selectedCategoryIndex == "2") {
      items = desserts;
    } else {
      items = pizza;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Foo", style: AppWidget.threelineTextFieldStyle()),
                      TextSpan(text: "D", style: AppWidget.twolineTextFieldStyle()),
                      TextSpan(text: "ei", style: AppWidget.onelineTextFieldStyle()),
                    ],
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "assets/profile.jpeg",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text("Order your favorite food!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search...",
                      hintStyle: TextStyle(fontSize: 16),
                    ),
                    onSubmitted: (value) => _handleSearch(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _handleSearch, // ✅ No parentheses here
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xfff84c6b),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ),
            ],
          ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index.toString();
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
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.70,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final FoodItem currentItem = items[index];
                  return _buildFoodTile(
                    image: currentItem.image,
                    name: currentItem.name,
                    price: currentItem.price,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPages(
                            image: currentItem.image,
                            name: currentItem.name,
                            price: currentItem.price,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTile({
    required String image,
    required String name,
    required String price,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xfffff0f3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.fastfood, size: 50, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: AppWidget.pizzestyleTextFieldStyle().copyWith(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "₹$price",
              style: AppWidget.pizzestyleTextFieldStyle().copyWith(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
