import 'package:deliveryapp/Admin/home_admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/Admin/all_order.dart';  // Your admin screen
import 'package:deliveryapp/service/widget_size.dart';

class AdminLoginpage extends StatefulWidget {
  const AdminLoginpage({Key? key}) : super(key: key);

  @override
  State<AdminLoginpage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginpage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void showSnackbar(String message, [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackbar("Email and password are required.", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🔍 Query instead of .add()
      final snapshot = await FirebaseFirestore.instance
          .collection('admin_users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      print("🔥 Docs found: ${snapshot.docs.length}");

      if (snapshot.docs.isEmpty) {
        showSnackbar("Invalid email or password.");
        return;
      }

      final doc = snapshot.docs.first;
      if (doc['role'] != 'admin') {
        showSnackbar("Access denied. Not an admin.");
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeAdmin()),
      );
    } catch (e) {
      print("❌ signIn error: $e");
      showSnackbar("Login failed: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffd0d1b4),
      body: Stack(
        children: [
          // Top image
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/burger12.jpg",
                  height: 200,
                  width: 240,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          // Form
          Container(
            height: MediaQuery.of(context).size.height / 1.7,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 3,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Admin Login",
                        style: AppWidget.signupTextFieldStyle(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text("Email", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildTextField(
                      hint: "Enter Email",
                      controller: _emailController,
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    Text("Password", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildPasswordField(),
                    const SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: signIn,
                        child: Container(
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    String? hint,
    IconData? icon,
    TextEditingController? controller,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon) : null,
            hintStyle: const TextStyle(fontSize: 16),
          ),
        ),
      );

  Widget _buildPasswordField() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Password",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        hintStyle: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
