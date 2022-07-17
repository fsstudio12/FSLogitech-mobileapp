import 'package:flutter/material.dart';
import 'package:nova/app_config.dart';
import 'package:nova/screens/login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              const Text(
                "Welcome",
                style: TextStyle(
                    fontSize: 32, color: primary, fontWeight: FontWeight.w600),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: Text(
                  "to",
                  style: TextStyle(
                      fontSize: 32,
                      color: primary,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Image.asset(
                "assets/images/finalized_nova_logo_full.png",
                height: 250,
                width: 250,
                fit: BoxFit.fill,
              ),
            ]),
            MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: primary,
                child: const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                })
          ],
        ),
      ),
    );
  }
}
