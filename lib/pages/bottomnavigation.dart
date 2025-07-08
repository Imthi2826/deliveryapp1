import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'homepage.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int selectedIndex = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const Homepage(),
    const Center(child: Text("Search Page")),
    const Center(child: Text("Detail Page")),
    const Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SlidingClippedNavBar(
              backgroundColor: Colors.transparent,
              onButtonPressed: (index) {
                setState(() {
                  selectedIndex = index;
                });
                controller.animateToPage(
                  selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.bounceIn,
                );
              },
              iconSize: 24,
              activeColor: const Color(0xFF01579B),
              selectedIndex: selectedIndex,
              barItems:  [
                BarItem(
                  icon: Icons.home,
                  title: 'Home',
                ),
                BarItem(
                  icon: Icons.search_rounded,
                  title: 'Search',
                ),
                BarItem(
                  icon: Icons.library_books_sharp,
                  title: 'Detail',
                ),
                BarItem(
                  icon: Icons.person,
                  title: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
