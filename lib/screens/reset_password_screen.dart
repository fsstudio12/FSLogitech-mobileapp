import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';
import '../app_config.dart';
import '../bloc/nova_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  NovaBloc posBloc = NovaBloc();

  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: primary),
    ),
  );
  String mailRegex =
      r'(^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$)';
  bool isEmailValid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primary,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
            ),
            child: StreamBuilder<int>(
                initialData: 0,
                stream: posBloc.outResetPasswordState,
                builder: (context, outResetPasswordStateSnapshot) {
                  return outResetPasswordStateSnapshot.data == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                "Email/Phone Number",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 15),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    // color: const Color.fromRGBO(236, 236, 236, 1),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            236, 236, 236, 1)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.black,
                                    contentPadding: EdgeInsets.only(left: 10),
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  color: primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text(
                                      "Get OTP",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (emailController.text.isNotEmpty &&
                                        isEmailValid) {
                                      posBloc.add(ResetPassword(
                                          context: context,
                                          email: emailController.text));
                                    }
                                  }),
                            ),
                          ],
                        )
                      : outResetPasswordStateSnapshot.data == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "OTP Verification",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "Enter OTP sent to ${emailController.text}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 15),
                                  child: Pinput(
                                    length: 6,
                                    controller: pinController,

                                    defaultPinTheme: defaultPinTheme,
                                    onCompleted: (pin) {
                                      // setState(() => showError = pin != '5555');
                                    },
                                    // focusedPinTheme: defaultPinTheme.copyWith(
                                    //   height: 68,
                                    //   width: 64,
                                    //   decoration: defaultPinTheme.decoration!.copyWith(
                                    //     border: Border.all(color: borderColor),
                                    //   ),
                                    // ),
                                    // errorPinTheme: defaultPinTheme.copyWith(
                                    //   decoration: BoxDecoration(
                                    //     color: errorColor,
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    // ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Didn’t get the code?"),
                                      InkWell(
                                          onTap: () {},
                                          child: const Text(
                                            " Re-send code",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    color: primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.only(top: 15, bottom: 15),
                                      child: Text(
                                        "Verify",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (emailController.text.isNotEmpty &&
                                          isEmailValid) {
                                        posBloc.add(ResetPassword(
                                            context: context,
                                            email: emailController.text));
                                      }
                                    }),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 15),
                                  child: Text(
                                    "New Password",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      // color: const Color.fromRGBO(236, 236, 236, 1),
                                      border: Border.all(color: darkGray),
                                      borderRadius:
                                          BorderRadius.circular((10))),
                                  child: Stack(
                                    children: [
                                      StreamBuilder<bool>(
                                          initialData: false,
                                          stream: posBloc
                                              .outPasswordObscureResponse,
                                          builder: (context, snapshot) {
                                            return TextFormField(
                                              obscureText: snapshot.data!,
                                              controller: passwordController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.only(left: 10),
                                              ),
                                            );
                                          }),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: StreamBuilder<bool>(
                                            initialData: false,
                                            stream: posBloc
                                                .outPasswordObscureResponse,
                                            builder: (context, snapshot) {
                                              return IconButton(
                                                  onPressed: () {
                                                    posBloc
                                                        .inPasswordObscureResponse
                                                        .add(!snapshot.data!);
                                                  },
                                                  icon: Icon(
                                                      snapshot.data!
                                                          ? Icons
                                                              .visibility_off_outlined
                                                          : Icons
                                                              .visibility_outlined,
                                                      color: primary));
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 15),
                                  child: Text(
                                    "Confirm Password",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      // color: const Color.fromRGBO(236, 236, 236, 1),
                                      border: Border.all(color: darkGray),
                                      borderRadius:
                                          BorderRadius.circular((10))),
                                  child: Stack(
                                    children: [
                                      StreamBuilder<bool>(
                                          initialData: false,
                                          stream: posBloc
                                              .outConfirmPasswordObscureResponse,
                                          builder: (context, snapshot) {
                                            return TextFormField(
                                              obscureText: snapshot.data!,
                                              controller:
                                                  confirmPasswordController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.only(left: 10),
                                              ),
                                              onChanged: (value) {
                                                // if (value != "") {
                                                //   posBloc.inPasswordsMatch.add(value);
                                                // } else {
                                                //   posBloc.inPasswordsMatch.add(null);
                                                // }
                                              },
                                            );
                                          }),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: StreamBuilder<bool>(
                                            initialData: false,
                                            stream: posBloc
                                                .outConfirmPasswordObscureResponse,
                                            builder: (context, snapshot) {
                                              return IconButton(
                                                  onPressed: () {
                                                    posBloc
                                                        .inConfirmPasswordObscureResponse
                                                        .add(!snapshot.data!);
                                                  },
                                                  icon: Icon(
                                                    snapshot.data!
                                                        ? Icons
                                                            .visibility_off_outlined
                                                        : Icons
                                                            .visibility_outlined,
                                                    color: primary,
                                                  ));
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      color: primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Text(
                                          "Reset",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (emailController.text.isNotEmpty &&
                                            isEmailValid) {
                                          posBloc.add(ResetPassword(
                                              context: context,
                                              email: emailController.text));
                                        }
                                      }),
                                ),
                              ],
                            );
                })),
      ),
    );
  }
}
