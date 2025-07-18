import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/pages/payment_pages.dart';

class Checkout extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String price;

  const Checkout({
    super.key,
    required this.cartItems,
    required this.price,
  });

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final couponController = TextEditingController();

  List<Map<String, dynamic>> firebaseOrders = [];
  double totalAmount = 0.0;
  bool isCouponApplied = false;
  String selectedState = 'Tamil Nadu';

  @override
  void initState() {
    super.initState();
    firebaseOrders = List<Map<String, dynamic>>.from(widget.cartItems);
    _calculateTotal();
  }

  void _calculateTotal() {
    double total = 0.0;
    for (var item in firebaseOrders) {
      int quantity = item['quantity'] ?? 1;
      num price = item['price'] ?? 0;
      item['total'] = quantity * price;
      total += item['total'];
    }

    if (isCouponApplied &&
        couponController.text.trim().toUpperCase() == "FOOD!100") {
      total *= 0.5;
    }

    setState(() {
      totalAmount = total;
    });
  }

  void _applyCoupon() {
    final coupon = couponController.text.trim().toUpperCase();
    setState(() {
      isCouponApplied = coupon == "FOOD!100";
    });
    _calculateTotal();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isCouponApplied ? "Coupon applied: 50% discount" : "Invalid coupon"),
      ),
    );
  }

  bool validateInputs() {
    final phone = phoneController.text.trim();
    final pincode = pincodeController.text.trim();
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    final pincodeRegex = RegExp(r'^[0-9]{6}$');

    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10-digit phone number")),
      );
      return false;
    }

    if (!pincodeRegex.hasMatch(pincode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 6-digit pincode")),
      );
      return false;
    }

    return true;
  }

  void _proceedToPayment() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        pincodeController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all delivery details.")),
      );
      return;
    }

    if (!validateInputs()) return;

    await FirebaseFirestore.instance.collection('orders').add({
      'name': nameController.text,
      'phone': "+91 ${phoneController.text}",
      'address': addressController.text,
      'state': selectedState,
      'pincode': pincodeController.text,
      'amount': totalAmount,
      'couponApplied': isCouponApplied,
      'cartItems': firebaseOrders,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          amount: totalAmount,
          name: nameController.text,
          phone: "+91 ${phoneController.text}",
          state: selectedState,
          pincode: pincodeController.text,
          address: addressController.text,
          cartItems: firebaseOrders,
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: hint.contains("Phone") || hint.contains("Pincode")
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: firebaseOrders.isEmpty
          ? const Center(child: Text("No items in cart."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Items",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              itemCount: firebaseOrders.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                final order = firebaseOrders[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: order['image'] != null
                          ? Image.asset(order['image'],
                          width: 60, height: 60, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported,
                          size: 60),
                    ),
                    title: Text(order['name'] ?? '',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon:
                          const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              int quantity = order['quantity'] ?? 1;
                              quantity -= 1;
                              if (quantity <= 0) {
                                firebaseOrders.removeAt(i);
                              } else {
                                order['quantity'] = quantity;
                                order['total'] = quantity *
                                    (order['price'] ?? 0);
                              }
                              _calculateTotal();
                            });
                          },
                        ),
                        Text('Qty: ${order['quantity']}'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              int quantity = order['quantity'] ?? 0;
                              quantity += 1;
                              order['quantity'] = quantity;
                              order['total'] = quantity *
                                  (order['price'] ?? 0);
                              _calculateTotal();
                            });
                          },
                        ),
                      ],
                    ),
                    trailing: Text(
                      "₹${(order['total'] ?? 0.0).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildInputField("Full Name", nameController),
            _buildInputField("Phone Number", phoneController),
            _buildInputField("Pincode", pincodeController),
            _buildInputField("Full Address", addressController,
                maxLines: 3),
            const SizedBox(height: 10),
            const Text("State"),
            DropdownButton<String>(
              value: selectedState,
              isExpanded: true,
              items: ['Tamil Nadu', 'Kerala']
                  .map((state) =>
                  DropdownMenuItem(value: state, child: Text(state)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Coupon"),
            Row(
              children: [
                Expanded(
                  child:
                  _buildInputField("Enter Coupon", couponController),
                ),
                IconButton(
                  onPressed: _applyCoupon,
                  icon: const Icon(Icons.discount),
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Pay Now",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
