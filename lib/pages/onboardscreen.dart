import 'package:deliveryapp/model/category_model.dart';
import 'package:deliveryapp/pages/homepage.dart';
import 'package:deliveryapp/service/widget_size.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<CategoryModel> categories=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width:MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top:20,bottom: 40),
        child: Column(
          children: [
            Lottie.asset("assets/delivery-boy.json",
            ),
            SizedBox(height: 20,),
            Text("The Fastest \n Food Delivery",
            textAlign: TextAlign.center,
            style: AppWidget.lineTextFieldStyle(),
            ),
            SizedBox(height: 20,),
            Text("Craving something delicious? \nOrder now and get your favorites \nDelivery fast!",
            textAlign: TextAlign.center,
              style: AppWidget.simplelineTextFieldStyle(),
            ),
            Spacer(),

            Container(
              height: 70,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(20)
              ),
              child: TextButton(onPressed: (){
                Navigator.pop(context,MaterialPageRoute(builder: (context)=>Homepage()));

              },
                  child: Text("Get Start",
                  style: TextStyle(color: Colors.white,fontSize: 15),
                  )),
            )
          ],

        ),
      ),
    );
  }
}
