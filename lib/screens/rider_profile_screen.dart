import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hive/hive.dart';
import 'package:nova/app_config.dart';

import '../services/hive_service.dart';
import 'login_screen.dart';

class RiderProfileScreen extends StatefulWidget {
  const RiderProfileScreen({Key? key}) : super(key: key);

  @override
  State<RiderProfileScreen> createState() => _RiderProfileScreenState();
}

class _RiderProfileScreenState extends State<RiderProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Profile")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                HiveService().getDriverDetail().image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(HiveService().getDriverDetail().name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            Text(HiveService().getDriverDetail().email,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: Text(HiveService().getDriverDetail().phone,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  )),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text("Sure want to logout?"),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: InkWell(
                              child: const Text("Yes"),
                              onTap: () {
                                Box box = HiveService().getNovaBox();
                                box.clear();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                            ),
                          ),
                          InkWell(
                            child: const Text("No"),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: darkGray),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, right: 15, left: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Icon(
                          PhosphorIcons.sign_in,
                          color: primary,
                        )
                      ]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
