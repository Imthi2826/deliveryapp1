import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isSearching = false;
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    categories = getCategories(); // No "User Added" tab
    pizza = getpizza();
    burger = getburger();
    desserts = getdessert();
    briyani = getbriyani();
  }

  void _handleSearch() {
    String query = _searchController.text.trim().toLowerCase();
    setState(() {
      isSearching = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodItem> localItems = selectedCategoryIndex == 0
        ? pizza
        : selectedCategoryIndex == 1
        ? burger
        : selectedCategoryIndex == 2
        ? desserts
        : selectedCategoryIndex == 3
        ? briyani
        : [];

    final selectedCategoryName = categories[selectedCategoryIndex].name!.toLowerCase();

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
              buildHeader(),
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
                          selectedCategoryIndex = index;
                          isSearching = false;
                          _searchController.clear();
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
              buildMergedGrid(localItems, selectedCategoryName),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMergedGrid(List<FoodItem> localItems, String categoryName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: categoryName)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<FoodItem> firestoreItems = [];
        if (snapshot.hasData) {
          firestoreItems = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return FoodItem.fromFirestore(data);
          }).toList();
        }

        // Merge local and Firestore items
        final allItems = [...localItems, ...firestoreItems];

        // Apply search if needed
        final displayItems = isSearching
            ? allItems
            .where((item) => item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList()
            : allItems;

        return buildGrid(displayItems);
      },
    );
  }

  Widget buildGrid(List<FoodItem> items) {
    return GridView.builder(
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
        final item = items[index];
        return _buildFoodTile(
          image: item.image,
          name: item.name,
          price: item.price,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPages(
                  image: item.image,
                  name: item.name,
                  price: item.price,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
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
                child: image.startsWith("http")
                    ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                )
                    : Image.asset(
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
            Text(name, style: AppWidget.pizzestyleTextFieldStyle().copyWith(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text("₹$price", style: AppWidget.pizzestyleTextFieldStyle().copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
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
