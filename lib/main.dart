import 'package:flutter/material.dart';

import 'app_config.dart';
import 'screens/splash_screen.dart';
import 'services/hive_service.dart';


Future<void> main() async {
  await HiveService().initHive();
  runApp(const Nova());
}

class Nova extends StatefulWidget {
  const Nova({Key? key}) : super(key: key);

  @override
  State<Nova> createState() => _NovaState();
}

class _NovaState extends State<Nova> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppConfig().themeData,
      home: const SplashScreen(),
    );
  }
}
