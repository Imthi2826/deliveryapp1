import 'package:flutter/material.dart';
import 'package:deliveryapp/pages/order_page.dart';
import 'package:deliveryapp/service/widget_size.dart';

import 'bottom_navigation.dart';

class DetailPages extends StatefulWidget {
  final String image;
  final String name;
  final String price;

  const DetailPages({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<DetailPages> createState() => _DetailPagesState();
}

class _DetailPagesState extends State<DetailPages> {
  int _quantity = 1;

  double get _itemPrice => double.tryParse(widget.price) ?? 0;
  double get _totalPrice => _itemPrice * _quantity;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _placeOrder() {
    final newOrder = {
      'name': widget.name,
      'image': widget.image,
      'quantity': _quantity,
      'total': _totalPrice,
      'status': 'Pending',
    };

    final index = OrderPage.orderList.indexWhere((order) => order['name'] == widget.name);
    if (index >= 0) {
      OrderPage.orderList[index]['quantity'] += _quantity;
      OrderPage.orderList[index]['total'] += _totalPrice;
    } else {
      OrderPage.orderList.add(newOrder);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed successfully!")),
    );

    // ✅ Go to Orders page WITH bottom nav
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavigation(selectedIndex: 1),
      ),
          (route) => false,
    );
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
              // Back
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xddb255b5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              // Image
              Center(
                child: Image.asset(
                  widget.image,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),

              Text(widget.name, style: AppWidget.lineTextFieldStyle().copyWith(fontSize: 24)),
              const SizedBox(height: 5),
              Text(
                "₹${_totalPrice.toStringAsFixed(2)}",
                style: AppWidget.onelineTextFieldStyle().copyWith(
                  fontSize: 22,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 15),

              const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text(
                "Delicious and freshly made with premium ingredients. Perfect for your cravings.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              const SizedBox(height: 20),
              const Text("QUANTITY", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          color: Colors.redAccent,
                        ),
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  Text(_quantity.toString(), style: const TextStyle(fontSize: 20)),
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
                          color: Colors.green,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
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
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: _placeOrder,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "Order Now",
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
