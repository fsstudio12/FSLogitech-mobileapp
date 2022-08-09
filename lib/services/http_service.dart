import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nova/services/hive_service.dart';

import '../app_config.dart';

class HttpService {
  login({String? contact, String? password}) async {
    try {
      Response? response = await http.post(
          Uri.parse("$baseUrl/employee/riderLogin"),
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
    String? method,
  }) async {
    try {
      // var request = http.Request('POST', Uri.parse('$baseUrl/rider/complete'));
      // request.body = json.encode({
      //   "orderId": "6295acf61183d0bbe7d63b4d",
      //   "riderId": "627a3365e99e664decf69dc5",
      //   "image": image,
      //   "method": method
      // });
      // request.headers.addAll(authHeader);

      // http.StreamedResponse streamedresponse = await request.send();
      // var response = await http.Response.fromStream(streamedresponse);

      // return response;
      Response? response = await http.post(Uri.parse("$baseUrl/rider/complete"),
          headers: authHeader,
          body: json.encode({
            "orderId": orderId,
            "riderId": HiveService().getDriverDetail().employeeId,
            "image": image,
            "method": method
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
            "orderId": orderId,
            "failReason": reason,
            "riderId": HiveService().getDriverDetail().employeeId,
          }));
      return response;
    } catch (e) {
      return null;
    }
  }
}
