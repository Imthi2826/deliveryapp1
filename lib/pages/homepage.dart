import 'package:deliveryapp/model/category_model.dart';
import 'package:deliveryapp/model/category_tile.dart';
import 'package:deliveryapp/model/fooditem.dart';
import 'package:deliveryapp/pages/Detail_pages.dart';
import 'package:deliveryapp/service/Briyani_data.dart';
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
  List<FoodItem> briyani = [];

  List<FoodItem> filteredItems = [];
  bool isSearching = false;

  int selectedCategoryIndex = 1;

  void _handleSearch() {
    String query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredItems = [];
      });
      return;
    }

    List<FoodItem> allItems = [...pizza, ...burger, ...desserts, ...briyani];
    List<FoodItem> matches = allItems.where(
          (item) => item.name.toLowerCase().contains(query),
    ).toList();

    setState(() {
      isSearching = true;
      filteredItems = matches;
    });

    if (matches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items found")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    pizza = getpizza();
    burger = getburger();
    desserts = getdessert();
    briyani = getbriyani();
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodItem> items = isSearching
        ? filteredItems
        : selectedCategoryIndex == 0
        ? pizza
        : selectedCategoryIndex == 1
        ? burger
        : selectedCategoryIndex == 2
        ? desserts
        : selectedCategoryIndex == 3
        ? briyani
        : [];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top + 16,
          16,
          0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Foo", style: AppWidget.threelineTextFieldStyle()),
                        TextSpan(text: "D", style: AppWidget.twolineTextFieldStyle()),
                        TextSpan(text: "eL", style: AppWidget.onelineTextFieldStyle()),
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
              const Text(
                "Order your favorite food!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Search bar
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search...",
                          hintStyle: const TextStyle(fontSize: 16),
                          suffixIcon: isSearching
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                isSearching = false;
                                filteredItems = [];
                              });
                            },
                          )
                              : null,
                        ),
                        onSubmitted: (_) => _handleSearch(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _handleSearch,
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
              const Text("OFFERS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Offers
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildOfferBanner(
                      title: "Burger Offers",
                      discount: "50%",
                      image: "assets/burger.jpg",
                    ),
                    const SizedBox(width: 10),
                    _buildOfferBanner(
                      title: "Pizza Offers",
                      discount: "50%",
                      image: "assets/pizza12.jpg",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Categories (disabled during search)
              if (!isSearching)
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                        child: CategoryTile(
                          name: categories[index].name!,
                          image: categories[index].image!,
                          categoryIndex: index.toString(),
                          selectedIndex: selectedCategoryIndex.toString(),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 15),

              // Food Items Grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.60,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferBanner({
    required String title,
    required String discount,
    required String image,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: const Color(0xfff4b3bf),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(discount, style: AppWidget.onelineTextFieldStyle()),
              const Spacer(),
              Image.asset(image, height: 80, width: 80),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Coupon code:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("FOOD!100")
            ],
          ),
        ],
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
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, size: 50, color: Colors.grey),
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
              style: AppWidget.pizzestyleTextFieldStyle()
                  .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
