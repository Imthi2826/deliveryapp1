import 'package:deliveryapp/pages/checkout.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  // Shared static list for storing orders
  static List<Map<String, dynamic>> orderList = [];

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  void _incrementQuantity(int index) {
    setState(() {
      final order = OrderPage.orderList[index];
      double unitPrice = order['total'] / order['quantity'];
      order['quantity'] += 1;
      order['total'] = unitPrice * order['quantity'];
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final order = OrderPage.orderList[index];
      double unitPrice = order['total'] / order['quantity'];

      if (order['quantity'] > 1) {
        order['quantity'] -= 1;
        order['total'] = unitPrice * order['quantity'];
      } else {
        OrderPage.orderList.removeAt(index);
      }
    });
  }

  void _addNewOrderItem(Map<String, dynamic> newOrder) {
    final existingIndex = OrderPage.orderList.indexWhere(
            (order) => order['name'] == newOrder['name']);

    if (existingIndex >= 0) {
      _incrementQuantity(existingIndex);
    } else {
      setState(() {
        OrderPage.orderList.add({
          ...newOrder,
          'status': 'Pending',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        actions: [
          if (OrderPage.orderList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                setState(() {
                  OrderPage.orderList.clear();
                });
              },
              tooltip: "Clear All Orders",
            ),
        ],
      ),
      body: OrderPage.orderList.isEmpty
          ? const Center(
        child: Text(
          "No orders placed yet.",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: OrderPage.orderList.length,
        itemBuilder: (context, index) {
          final order = OrderPage.orderList[index];
          double unitPrice = order['total'] / order['quantity'];

          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      order['image'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Info and quantity
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['name'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _decrementQuantity(index),
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.redAccent,
                                child: Icon(Icons.remove,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              order['quantity'].toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                _addNewOrderItem({
                                  'name': order['name'],
                                  'image': order['image'],
                                  'quantity': 1,
                                  'total': unitPrice,
                                });
                              },
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.green,
                                child: Icon(Icons.add,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Price & badge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.hourglass_top,
                                size: 16, color: Colors.orange),
                            SizedBox(width: 4),
                            Text(
                              "Pending",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹${order['total'].toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: OrderPage.orderList.isNotEmpty
          ? Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        height: 80,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)
        ),
            child: FloatingActionButton.extended(
                    onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Checkout()),
            );
                    },
                    icon: const Icon(Icons.payment,),
                    label: const Text("Checkout"),
                    backgroundColor: Colors.green,
                  ),
          )
          : null,
    );
  }
}
