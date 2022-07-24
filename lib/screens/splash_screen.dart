import 'package:flutter/material.dart';
import 'package:nova/screens/landing_screen.dart';

import 'package:nova/services/hive_service.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      HiveService().getDriverDetail() == null
          ? Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LandingScreen()))
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        "assets/images/finalized_nova_logo.png",
        height: 132.61,
        width: 157.1,
        fit: BoxFit.fill,
      )),
    );
  }
}
