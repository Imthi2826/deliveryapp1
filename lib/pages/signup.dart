import 'package:deliveryapp/service/widget_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  final VoidCallback showLoginPage;

  const Signup({super.key, required this.showLoginPage});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // 🔐 Firebase register function
  Future<void> register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackbar("All fields are required", Colors.orange);
      return;
    }

    if (!email.contains("@")) {
      _showSnackbar("Enter a valid email");
      return;
    }

    if (password.length < 6) {
      _showSnackbar("Password must be at least 6 characters");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _showSnackbar("Registered Successfully", Colors.green);

      // Optional: Redirect or save extra data here

    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        message = "Account already exists";
      } else {
        message = e.message ?? "Registration failed";
      }
      _showSnackbar(message);
    }
  }

  void _showSnackbar(String msg, [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd0d1b4),
      body: Stack(
        children: [
          // 🖼 Background Image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"), fit: BoxFit.cover),
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
                  fit: BoxFit.fill,
                  width: 240,
                ),
              ),
            ),
          ),

          // 📝 Signup Form
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
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("Sign up", style: AppWidget.signupTextFieldStyle())),
                    const SizedBox(height: 16),

                    Text("Name", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildTextField(
                        hint: "Enter Name",
                        controller: _nameController,
                        icon: Icons.person),

                    const SizedBox(height: 16),
                    Text("Email", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildTextField(
                        hint: "Enter Email",
                        controller: _emailController,
                        icon: Icons.email),

                    const SizedBox(height: 16),
                    Text("Password", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildPasswordField(),

                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: register,
                        child: Container(
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text("Sign Up",
                                style: AppWidget.signupTextFieldStyle()),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: widget.showLoginPage,
                          child: const Text("LogIn",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.blue)),
                        )
                      ],
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

  // 🧩 Generic TextField
  Widget _buildTextField({
    String? hint,
    IconData? icon,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          hintStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // 🔒 Password TextField with toggle
  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
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
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          hintStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
