import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_page.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String name;
  final String phone;
  final String state;
  final String pincode;
  final String address;

  const PaymentPage({
    super.key,
    required this.amount,
    required this.name,
    required this.phone,
    required this.state,
    required this.pincode,
    required this.address,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Set<int> _expandedItems = {};

  double getOriginalTotal() {
    return OrderPage.orderList.fold(
      0.0,
          (sum, item) => sum + (item['total'] as double),
    );
  }

  Future<void> _handlePayment() async {
    final discountedAmount = widget.amount;

    for (var order in OrderPage.orderList) {
      await FirebaseFirestore.instance.collection('orders').add({
        'name': order['name'],
        'image': order['image'],
        'quantity': order['quantity'],
        'total': order['total'],
        'status': 'Paid',
        'timestamp': Timestamp.now(),
        'customer': {
          'name': widget.name,
          'phone': widget.phone,
          'state': widget.state,
          'pincode': widget.pincode,
          'address': widget.address,
        }
      });
    }

    OrderPage.orderList.clear(); // Clear orders locally

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("✅ Payment Successful",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 60, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              "Your payment of ₹${discountedAmount.toStringAsFixed(2)} was successful!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double originalTotal = getOriginalTotal();
    final double discountedAmount = widget.amount;
    final double discount = originalTotal - discountedAmount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "Add More Items",
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: OrderPage.orderList.isEmpty
          ? const Center(
        child: Text(
          "🛒 No items in your order.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Column(
        children: [
          // Address Info
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Delivery Address",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(widget.name),
                  Text(widget.phone),
                  Text(
                      "${widget.address}, ${widget.state} - ${widget.pincode}"),
                ],
              ),
            ),
          ),

          // Orders
          Expanded(
            child: ListView.builder(
              itemCount: OrderPage.orderList.length,
              itemBuilder: (context, index) {
                final order = OrderPage.orderList[index];
                final isExpanded = _expandedItems.contains(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ExpansionTile(
                      tilePadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          expanded
                              ? _expandedItems.add(index)
                              : _expandedItems.remove(index);
                        });
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(order['image'],
                            width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(order['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      subtitle:
                      Text("Quantity: ${order['quantity']}"),
                      trailing: Text(
                        "₹${order['total'].toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 18, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text("Status: ${order['status']}",
                                  style: const TextStyle(
                                      color: Colors.orange)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Summary + Button
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Text("Payment Summary",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildSummaryRow("Total (Before Discount)",
                    originalTotal), // full
                _buildSummaryRow("Coupon Discount", -discount),
                const Divider(thickness: 1, height: 24),
                _buildSummaryRow("Amount to Pay", discountedAmount,
                    isTotal: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _handlePayment,
                    icon: const Icon(Icons.payment),
                    label: const Text("Proceed to Pay",
                        style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            )),
        Text(
          (amount < 0 ? "- " : "") + "₹${amount.abs().toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
