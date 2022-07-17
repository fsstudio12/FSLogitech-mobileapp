import 'dart:convert';
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

  getPickupDetail({String? id}) async {
    try {
      Response? response = await http.post(Uri.parse(baseUrl + "/one"),
          headers: authHeader,
          body: json.encode({
            "driverId": HiveService().getDriverDetail().userId,
            "applicationId": id
          }));
      return response;
    } catch (e) {
      return null;
    }
  }

  getCalendarDetail() async {
    try {
      Response? response = await http.post(Uri.parse(baseUrl + "/calendar"),
          headers: authHeader,
          body: json.encode({
            "driverId": HiveService().getDriverDetail().userId,
          }));
      return response;
    } catch (e) {
      return null;
    }
  }

  // startPickupService(
  //     {String? applicationId, List<File>? proofImages, File? signature}) async {
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/test'));
  //     request.fields.addAll({
  //       'driverId': HiveService().getDriverDetail().userId,
  //       'byteA': applicationId!
  //     });
  //     for (var element in proofImages!) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //           'proof', element.path.split('/').last));
  //     }

  //     request.files.add(await http.MultipartFile.fromPath(
  //         'signature', signature!.path.split('/').last));

  //     request.headers.addAll(authHeader);

  //     dynamic response = await http.Response.fromStream(await request.send());

  //     return response;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  startPickupService(
      {String? applicationId,
      List<Uint8List>? proofImages,
      Uint8List? signature,
      List<Product>? products}) async {
    try {
      Response? response = await http.post(Uri.parse(baseUrl + "/mark_picked"),
          headers: authHeader,
          body: json.encode({
            "driverId": HiveService().getDriverDetail().userId,
            "applicationId": applicationId,
            "signature": signature,
            "proofImages": proofImages,
            "products": products
          }));
      return response;
    } catch (e) {
      return null;
    }
  }

  markFailedService({String? applicationId, String? reason}) async {
    try {
      Response? response = await http.post(Uri.parse(baseUrl + "/mark_failed"),
          headers: authHeader,
          body: json.encode({
            "driverId": HiveService().getDriverDetail().userId,
            "applicationId": applicationId,
            "reason": reason
          }));
      return response;
    } catch (e) {
      return null;
    }
  }

  retryPickupService({String? applicationId, String? reason}) async {
    try {
      Response? response = await http.post(Uri.parse(baseUrl + "/retry_pickup"),
          headers: authHeader,
          body: json.encode({
            "applicationId": applicationId,
          }));
      return response;
    } catch (e) {
      return null;
    }
  }
}
