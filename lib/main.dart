
import 'package:deliveryapp/Admin/admin_loginpage.dart';
import 'package:deliveryapp/Admin/home_admin.dart';
import 'package:deliveryapp/pages/bottom_navigation.dart';
import 'package:deliveryapp/pages/onboardscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavigation(selectedIndex: 0),
      debugShowCheckedModeBanner: false,
    );
  }
}
