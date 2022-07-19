import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'services/hive_service.dart';

class AppConfig {
  ThemeData themeData = ThemeData(
      fontFamily: "Work Sans",
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          actionsIconTheme: IconThemeData(color: Colors.black)),
      iconTheme: const IconThemeData(color: Colors.black));

  DateFormat standardDate = DateFormat("yyyy-MM-dd");

  DateFormat standardDate1 = DateFormat("MMMM dd yyyy");
  DateFormat timeFormat = DateFormat("jm");
  NumberFormat standardCurrency =
      NumberFormat.currency(customPattern: '##,##,###.#');
  NumberFormat standardCrypto = NumberFormat.compact();

  shimmers(context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.blue.shade500,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: Colors.grey.shade300,
              height: 10,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Container(
                color: Colors.grey.shade300,
                height: 20,
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ),
            Container(
              color: Colors.grey.shade300,
              height: 5,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                color: Colors.grey.shade300,
                height: 50,
                width: MediaQuery.of(context).size.width / 1.8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                color: Colors.grey.shade300,
                height: 100,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                color: Colors.grey.shade300,
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                color: Colors.grey.shade300,
                height: 50,
                width: MediaQuery.of(context).size.width / 1.3,
              ),
            ),
            Container(
              color: Colors.grey.shade300,
              height: 10,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Container(
                color: Colors.grey.shade300,
                height: 20,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              color: Colors.grey.shade300,
              height: 5,
              width: MediaQuery.of(context).size.width / 1.2,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                color: Colors.grey.shade300,
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                color: Colors.grey.shade300,
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Container(
                color: Colors.grey.shade300,
                height: 20,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                color: Colors.grey.shade300,
                height: 100,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ]),
        ));
  }
}

const Color primary = Color(0xFF0046A0);
const Color secondary = Color(0xFFF7941E);
const Color link = Color(0xFF192FA4);
const Color pale = Color(0xFFEFEFF7);
const Color darkGray = Color(0xFF6B6B6B);
const Color gray = Color(0xFFBDBABA);
const Color processing = Color(0xFF3C91E6);
const Color failed = Color(0xFF8F2D56);
const Color completed = Color(0xFF2DCEBB);
const Color pending = Color(0xFFFFD322);

//google map url

const mapUrl = "https://www.google.com/maps/search/?api=1";

//base url

const baseUrl = "http://192.168.1.89:3011";

//auth header
var authHeader = {
  'Content-Type': 'application/json',
  'x-api-key': 'd3d42f9b-5b2b-483b-976a-c4c7e81e9e8e',
  'Authorization': 'Bearer ${HiveService().getDriverDetail().jwtToken}',
};
