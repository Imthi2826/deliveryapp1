import 'package:deliveryapp/pages/login_page.dart';
import 'package:deliveryapp/pages/signup.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showLoginPage = true;

  // Switch between login and signup
  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(showSignup: toggleScreen)
        : Signup(showLoginPage: toggleScreen);
  }
}
