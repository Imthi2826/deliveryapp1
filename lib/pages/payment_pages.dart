import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_page.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String name;
  final String phone;
  final String state;
  final String pincode;
  final String address;
  final List<Map<String, dynamic>> cartItems;

  const PaymentPage({
    super.key,
    required this.amount,
    required this.name,
    required this.phone,
    required this.state,
    required this.pincode,
    required this.cartItems,
    required this.address,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double getOriginalTotal() {
    return widget.cartItems.fold(
        0.0, (sum, item) => sum + (item['total'] as num));
  }

  Future<void> _handlePayment() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('orders').add({
      'status': 'Pending',
      'customer_name': widget.name,
      'phone': widget.phone,
      'state': widget.state,
      'pincode': widget.pincode,
      'address': widget.address,
      'items': widget.cartItems,
      'userId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'total': widget.amount,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrderPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double originalTotal = getOriginalTotal();
    final double discountedAmount = widget.amount;
    final double discount = originalTotal - discountedAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildStepProgressIndicator(),
          const SizedBox(height: 12),
          _buildAddressCard(),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Order Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: widget.cartItems.isEmpty
                ? const Center(child: Text("No items in cart"))
                : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(item['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 4),
                              Text("Qty: ${item['quantity']}",
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        Text("₹${item['total'].toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildPaymentSummary(originalTotal, discount, discountedAmount),
        ],
      ),
    );
  }

  Widget _buildStepProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep("Address", true),
          _buildDividerLine(),
          _buildStep("Review", true),
          _buildDividerLine(),
          _buildStep("Pay", false),
        ],
      ),
    );
  }

  Widget _buildStep(String label, bool isDone) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: isDone ? Colors.orange : Colors.grey[300],
          child: Icon(isDone ? Icons.check : Icons.circle,
              color: Colors.white, size: 18),
          radius: 14,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildDividerLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.orange,
      ),
    );
  }

  Widget _buildAddressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDeliveryRow("Name", widget.name),
            _buildDeliveryRow("Phone", widget.phone),
            _buildDeliveryRow("Pincode", widget.pincode),
            _buildDeliveryRow("State", widget.state),
            _buildDeliveryRow("Address", widget.address),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(
      double original, double discount, double finalAmount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Text("Payment Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSummaryRow("Total (Before Discount)", original),
          _buildSummaryRow("Coupon Discount", -discount),
          const Divider(thickness: 1, height: 24),
          _buildSummaryRow("Amount to Pay", finalAmount, isTotal: true),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _handlePayment,
              icon: const Icon(Icons.payment),
              label:
              const Text("Proceed to Pay", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
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
          "${amount < 0 ? "- " : ""}₹${amount.abs().toStringAsFixed(2)}",
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
