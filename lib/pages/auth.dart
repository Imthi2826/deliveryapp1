import 'package:deliveryapp/pages/login_page.dart';
import 'package:deliveryapp/pages/signup.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool showLoginPage =true;

  void toggleScreen(){
    setState(() {
      showLoginPage =!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(showSignup: toggleScreen);
    }
    else {
      return Signup(showLoginPage: toggleScreen);
    }
  }
}
