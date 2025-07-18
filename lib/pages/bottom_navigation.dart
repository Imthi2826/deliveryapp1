import 'package:deliveryapp/pages/Detail_pages.dart';
import 'package:deliveryapp/pages/order_page.dart';
import 'package:deliveryapp/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'homepage.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  const BottomNavigation({super.key, required this.selectedIndex});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    controller = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const Homepage(),
    const OrderPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 8,
          shadowColor: Colors.black54,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SlidingClippedNavBar(
              backgroundColor: Colors.white,
              onButtonPressed: (index) {
                setState(() {
                  selectedIndex = index;
                });
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              iconSize: 26,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey.shade600,
              selectedIndex: selectedIndex,
              barItems:  [
                BarItem(icon: Icons.home_rounded, title: 'Home'),
                BarItem(icon: Icons.shopping_cart_outlined, title: 'Orders'),
                BarItem(icon: Icons.person_outline, title: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
