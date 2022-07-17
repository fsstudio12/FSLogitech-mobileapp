import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nova/bloc/nova_bloc.dart';

import '../app_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  NovaBloc novaBloc = NovaBloc();

  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 15),
              child: Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 32, color: primary),
              ),
            ),
            const Text(
              "Email or Phone",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: TextField(
                controller: contactController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            const Text(
              "Password",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, top: 10),
              child: StreamBuilder<bool>(
                  initialData: false,
                  stream: novaBloc.outIsObscured,
                  builder: (context, outIsObscuredSnapshot) {
                    return Stack(
                      children: [
                        TextField(
                          controller: passwordController,
                          obscureText: outIsObscuredSnapshot.data!,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                novaBloc.inIsObscured
                                    .add(!outIsObscuredSnapshot.data!);
                              },
                              icon: Icon(outIsObscuredSnapshot.data!
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined)),
                        )
                      ],
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 14.0,
                      width: 14.0,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          value: true,
                          onChanged: (value) {}),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Remember me",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 12, color: link),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 15),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minWidth: MediaQuery.of(context).size.width,
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
                    novaBloc.add(LoginEvent(
                        password: passwordController.text,
                        phoneNumber: contactController.text,
                        context: context));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
