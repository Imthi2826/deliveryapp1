import 'package:deliveryapp/service/widget_size.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  final VoidCallback showLoginPage;

  const Signup({super.key, required this.showLoginPage});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd0d1b4),
      body: Stack(
        children: [
          // Top image section
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration:  BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/background.png"),fit: BoxFit.cover),
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

          // Signup form section
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
                    Center(
                      child: Text(
                        "Sign up",
                        style: AppWidget.signupTextFieldStyle(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text("Name", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildTextField(hint: "Name"),

                    const SizedBox(height: 16),
                    Text("Email", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildTextField(
                      hint: "Enter Email",
                      controller: _emailController,
                      icon: Icons.person,
                    ),

                    const SizedBox(height: 16),
                    Text("Password", style: AppWidget.signupTextFieldStyle()),
                    const SizedBox(height: 8),
                    _buildPasswordField(),

                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        height: 50,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: AppWidget.signupTextFieldStyle(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,
                        )),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: widget.showLoginPage,
                            child: Text("LogIn",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue),))
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

  // Reusable normal text field
  Widget _buildTextField({
    String? hint,
    IconData? icon,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          hintStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Reusable password field with toggle visibility
  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey,
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
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          hintStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
