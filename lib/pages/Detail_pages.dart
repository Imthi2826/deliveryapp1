import 'dart:core';
import 'package:deliveryapp/service/widget_size.dart';
import 'package:flutter/material.dart';

class DetailPages extends StatefulWidget {
  final String image;
  final String name;
  final String price;

  DetailPages({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<DetailPages> createState() => _PizzaPageState();
}

class _PizzaPageState extends State<DetailPages> {
  int _quantity = 1;

  // Convert price string to double
  double get _itemPrice => double.tryParse(widget.price) ?? 50.0;
  double get _totalPrice => _itemPrice * _quantity;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xddb255b5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.name,
                style: AppWidget.lineTextFieldStyle().copyWith(fontSize: 24),
              ),
              const SizedBox(height: 5),
              Text(
                "₹${_totalPrice.toStringAsFixed(2)}",
                style: AppWidget.onelineTextFieldStyle()
                    .copyWith(fontSize: 22, color: Colors.green.shade700),
              ),
              const SizedBox(height: 15),
              Text(
                "Description",
                style: AppWidget.lineTextFieldStyle().copyWith(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: const Text(
                  "Mozzarella is a classic cheese for pizza. However, feel free to change things up. Some of my other favorite cheeses are cheddar, provolone, goat cheese, and burrata cheese.",
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, height: 1.4),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "QUANTITY",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: _decrementQuantity,
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFE53935),
                        ),
                        child: const Icon(Icons.remove,
                            size: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  Text(
                    _quantity.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: _incrementQuantity,
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF4CAF50),
                        ),
                        child: const Icon(Icons.add,
                            size: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Total: ₹${_totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (_quantity == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Please select at least 1 pizza")),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Order placed for $_quantity pizza(s) at ₹${_totalPrice.toStringAsFixed(2)}"),
                        ));
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "Order Now",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
