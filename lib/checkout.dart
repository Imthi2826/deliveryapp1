import 'package:flutter/material.dart';
import 'order_page.dart';
import 'payment_pages.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController couponController = TextEditingController();




  double totalAmount = 0.0;
  bool isCouponApplied = false;

  @override
  void initState() {
    super.initState();
    _calculateTotal(); // Initial total
  }

  void _calculateTotal() {
    double total = 0;
    for (var order in OrderPage.orderList) {
      total += order['total'];
    }

    // Apply 50% discount only if coupon is valid and applied
    if (isCouponApplied &&
        (couponController.text.trim() == "FOOD!100" ||
            couponController.text.trim().startsWith("FOOD!100"))) {
      total *= 0.5;
    }

    setState(() {
      totalAmount = total;
    });
  }

  void _applyCoupon() {
    final coupon = couponController.text.trim();

    if (coupon == "FOOD!100" || coupon.startsWith("FOOD!100")) {
      isCouponApplied = true;
      _calculateTotal();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coupon applied: 50% discount")),
      );
    } else {
      isCouponApplied = false;
      _calculateTotal();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid coupon code")),
      );
    }
  }

  void _proceedToPayment() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        pincodeController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all delivery details.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          amount: totalAmount,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          state: stateController.text.trim(),
          pincode: pincodeController.text.trim(),
          address: addressController.text.trim(),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            for (var order in OrderPage.orderList)
              ListTile(
                leading: Image.asset(order['image'], width: 50, height: 50),
                title: Text(order['name']),
                subtitle: Text("Qty: ${order['quantity']}"),
                trailing: Text(
                  "₹${order['total'].toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.green),
                ),
              ),

            const SizedBox(height: 20),
            _buildInputField("Full Name", controller: nameController),
            const SizedBox(height: 10),
            _buildInputField("Phone Number", controller: phoneController),
            const SizedBox(height: 10),
            _buildInputField("Pincode", controller: pincodeController),
            const SizedBox(height: 10),
            _buildInputField("State", controller: stateController),
            const SizedBox(height: 10),
            _buildInputField("Full Address",
                controller: addressController, maxLines: 3),

            const SizedBox(height: 25),
            const Text("Add Coupon",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildInputField("Insert your coupon code",
                      controller: couponController),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _applyCoupon,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.discount, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
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
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Pay Now",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint,
      {TextEditingController? controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
