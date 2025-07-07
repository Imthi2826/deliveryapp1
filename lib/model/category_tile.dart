import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  final String name;
  final String image;
  final String categoryIndex;
  final String selectedIndex; // 👈 passed from parent

  const CategoryTile({
    super.key,
    required this.name,
    required this.image,
    required this.categoryIndex,
    required this.selectedIndex,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.categoryIndex == widget.selectedIndex;

    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xfff40404) : const Color(0x86514d50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset(
            widget.image,
            height: 30,
            width:30,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
