import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nova/services/hive_service.dart';

import '../app_config.dart';
import '../models/nova_model.dart';

class HttpService {
  login({String? contact, String? password}) async {
    try {
      Response? response = await http.post(Uri.parse("$baseUrl/employee/login"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": "d3d42f9b-5b2b-483b-976a-c4c7e81e9e8e"
          },
          body: json.encode(
              {"contact": "mars.3.zutsu@gmail.com", "password": "ashish"}));
      return response;
    } catch (e) {
      return null;
    }
  }

  getCalendar() async {
    try {
      Response? response = await http.post(Uri.parse("$baseUrl/rider/month"),
          headers: authHeader,
          body: json
              .encode({"riderId": HiveService().getDriverDetail().employeeId}));
      return response;
    } catch (e) {
      return null;
    }
  }

  startDelivery({List? orderIds}) async {
    try {
      Response? response = await http.post(Uri.parse("$baseUrl/rider/start"),
          headers: authHeader,
          body: json.encode({
            "orderIds": orderIds,
            "riderId": HiveService().getDriverDetail().employeeId
          }));
      return response;
    } catch (e) {
      return null;
    }
  }

  completeDeliveryService({
    String? orderId,
    Uint8List? image,
  }) async {
    try {
      Response? response = await http.post(Uri.parse("$baseUrl/rider/complete"),
          headers: authHeader,
          body: json.encode({
            "riderId": HiveService().getDriverDetail().userId,
            "orderId": orderId,
            "image": image,
          }));
      return response;
    } catch (e) {
      return null;
    }
  }

  markFailedService({String? orderId, String? reason}) async {
    try {
      Response? response = await http.post(Uri.parse("$baseUrl/rider/fail"),
          headers: authHeader,
          body: json.encode({
            "riderId": HiveService().getDriverDetail().userId,
            "orderId": orderId,
            "failReason": reason
          }));
      return response;
    } catch (e) {
      return null;
    }
  }
}
