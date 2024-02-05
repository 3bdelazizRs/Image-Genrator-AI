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
        child: Lottie.asset("assets/s_loading.json"),
      ),
    );
  }
}
