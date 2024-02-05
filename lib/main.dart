import 'package:flutter/material.dart';
import 'package:image_genrator_ai/Home.dart';
import 'package:image_genrator_ai/Pages/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const SplashScreen(),
        "home":(context)=>const Home(),
      },
    );
  }
}
