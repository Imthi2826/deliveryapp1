import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Future<void> _markAsDelivered(String docId) async {
    await FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'status': 'Delivered',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found", style: TextStyle(fontSize: 18)));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final docId = orders[index].id;

              final String status = order['status'] ?? 'Pending';
              final bool isPending = status == 'Pending';
              final item = (order['items'] as List?)?.isNotEmpty == true ? order['items'][0] : null;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item != null && item['image'] != null
                              ? Image.asset(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('', width: 60, height: 60),
                          )
                              : Image.asset('', width: 60, height: 60),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item?['name'] ?? 'Item',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text("Customer: ${order['customer_name'] ?? 'N/A'}"),
                              Text("Phone: ${order['phone'] ?? 'N/A'}"),
                              Text(
                                  "Address: ${order['address'] ?? ''}, ${order['state'] ?? ''} - ${order['pincode'] ?? ''}"),
                              Text(
                                "Ordered on: ${order['timestamp']?.toDate().toString().split('.')[0] ?? ''}",
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "₹${(order['total'] ?? 0).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isPending ? Colors.orange.shade100 : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPending ? Icons.timelapse_outlined : Icons.check_circle_outline,
                                color: isPending ? Colors.orange : Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isPending ? 'Pending' : 'Delivered',
                                style: TextStyle(
                                  color: isPending ? Colors.orange : Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isPending)
                          ElevatedButton(
                            onPressed: () => _markAsDelivered(docId),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text("Mark Delivered"),
                          ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
