import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_genrator_ai/constants/constants.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('home');
    });
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                //color: Colors.deepOrangeAccent,
                child: Lottie.asset("assets/loading_s.json",
                    width: 150, height: 100, fit: BoxFit.fill)),
            Text(
              "Image Generator AI",
              style: TextStyle(color: Colors.white, fontFamily: 'Rubik'),
            )
          ],
        ),
      ),
    );
  }
}
