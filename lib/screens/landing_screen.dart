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
              Image.asset(
                "assets/images/finalized_nova_logo_full.png",
                // height: 132.33,
                // width: 156.77,
                height: 105.76,
                width: 109,
                fit: BoxFit.fill,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 27, bottom: 5),
                child: Text(
                  "Watch & engage",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                ),
              ),
              const Text(
                "wherever, whenever",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 47, bottom: 10),
                child: Image.asset(
                  "assets/images/landing.png",
                  height: 264.52,
                  width: 328,
                  fit: BoxFit.fill,
                ),
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
                        color: Colors.white, fontWeight: FontWeight.w600),
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
