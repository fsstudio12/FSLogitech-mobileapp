import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';

import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nova/app_config.dart';

import 'package:nova/screens/home_screen.dart';
import 'package:nova/screens/landing_screen.dart';
import 'package:nova/services/hive_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import '../models/nova_model.dart';

import '../screens/toast.dart';
import '../services/http_service.dart';

part 'nova_event.dart';
part 'nova_state.dart';

class NovaBloc extends Bloc<NovaEvent, NovaState> {
  final StreamController<bool> _isObscuredStreamController = BehaviorSubject();
  Stream<bool> get outIsObscured => _isObscuredStreamController.stream;
  Sink<bool> get inIsObscured => _isObscuredStreamController.sink;

  final StreamController<LoginResponseModel> _loginResponseStreamController =
      BehaviorSubject();
  Stream<LoginResponseModel> get outLoginResponse =>
      _loginResponseStreamController.stream;
  Sink<LoginResponseModel> get inLoginResponse =>
      _loginResponseStreamController.sink;

  final StreamController<CalendarResponseModel>
      _calendarResponseStreamController = BehaviorSubject();
  Stream<CalendarResponseModel> get outCalendarResponse =>
      _calendarResponseStreamController.stream;
  Sink<CalendarResponseModel> get inCalendarResponse =>
      _calendarResponseStreamController.sink;

  final StreamController<PickupDetailResponseModel>
      _pickUpDetailResponseStreamController = BehaviorSubject();
  Stream<PickupDetailResponseModel> get outPickupDetailResponse =>
      _pickUpDetailResponseStreamController.stream;
  Sink<PickupDetailResponseModel> get inPickupDetailResponse =>
      _pickUpDetailResponseStreamController.sink;

  //start pickup streams

  final StreamController<bool> _startPickupProductsConfirmedStreamController =
      BehaviorSubject();
  Stream<bool> get outStartPickupProductsConfirmed =>
      _startPickupProductsConfirmedStreamController.stream;
  Sink<bool> get inStartPickupProductsConfirmed =>
      _startPickupProductsConfirmedStreamController.sink;

  final StreamController<List<Uint8List>>
      _startPickupProofImagesStreamController = BehaviorSubject();
  Stream<List<Uint8List>> get outStartPickupProofImages =>
      _startPickupProofImagesStreamController.stream;
  Sink<List<Uint8List>> get inStartPickupProofImages =>
      _startPickupProofImagesStreamController.sink;

  final StreamController<Uint8List> _startPickupSignatureStreamController =
      BehaviorSubject();
  Stream<Uint8List> get outStartPickupSignature =>
      _startPickupSignatureStreamController.stream;
  Sink<Uint8List> get inStartPickupProofSignature =>
      _startPickupSignatureStreamController.sink;

  final StreamController<List<num>> _deletedProductsIndexListStreamController =
      BehaviorSubject();
  Stream<List<num>> get outDeletedProductsIndexList =>
      _deletedProductsIndexListStreamController.stream;
  Sink<List<num>> get inDeletedProductsIndexList =>
      _deletedProductsIndexListStreamController.sink;

  final StreamController<bool> _isProcessing = BehaviorSubject();
  Stream<bool> get outIsProcessing => _isProcessing.stream;
  Sink<bool> get inIsProcessing => _isProcessing.sink;
  void dispose() {
    // _isObscuredStreamController.close();
    // _loginResponseStreamController.close();

    // _pickUpDetailResponseStreamController.close();

    // _startPickupProductsConfirmedStreamController.close();
    // _startPickupProofImagesStreamController.close();
    // _startPickupSignatureStreamController.close();
    // _deletedProductsIndexListStreamController.close();
    // _isProcessing.close();
  }

  NovaBloc() : super(OvaInitial()) {
    on<NovaEvent>((event, emit) async {
      if (event is LoginEvent) {
        Response? response = await HttpService()
            .login(password: event.password, contact: event.phoneNumber);

        if (response != null) {
          if (response.statusCode == 200) {
            inLoginResponse.add(loginResponseModelFromJson(response.body));
            LoginResponseModel loginResponse =
                LoginResponseModel.fromJson(json.decode(response.body));
            HiveService().saveDriverDetail(loginResponse.data!);
            print(HiveService().getDriverDetail().name);

            Navigator.of(event.context!).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else {
            Toast.show("Something went wrong!", event.context!,
                gravity: Toast.bottom, backgroundColor: primary, duration: 2);
          }
        } else {
          Toast.show("Something went wrong!", event.context!,
              gravity: Toast.bottom, backgroundColor: primary, duration: 2);
        }
      }

      if (event is GetCalendarEvent) {
        Response? response = await HttpService().getCalendar();

        if (response != null) {
          if (response.statusCode == 200) {
            inCalendarResponse
                .add(calendarResponseModelFromJson(response.body));
            event.refreshController!.refreshCompleted();
          }
        }
      }

      if (event is GetPickupDetailEvent) {
        Response? response = await HttpService().getPickupDetail(id: event.id);

        if (response != null) {
          debugPrint(response.body);
          if (response.statusCode == 200) {
            inPickupDetailResponse
                .add(pickupDetailResponseModelFromJson(response.body));
          }
        }
      }

      if (event is StartPickupEvent) {
        Response? response = await HttpService().startPickupService(
            applicationId: event.applicationId,
            products: event.products,
            proofImages: event.proofImages,
            signature: event.signature);

        if (response != null) {
          if (response.statusCode == 200) {
            inIsProcessing.add(false);
            Toast.show("Pickup processed successfully!", event.context!,
                gravity: Toast.bottom, backgroundColor: primary, duration: 2);

            // ScaffoldMessenger.of(event.context!).showSnackBar(const SnackBar(
            //     content: Text("Pickup processed successfully!")));
            Navigator.of(event.context!).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }
      }
      if (event is MarkFailedEvent) {
        Response? response = await HttpService().markFailedService(
            applicationId: event.applicationId, reason: event.reason);

        if (response != null) {
          if (response.statusCode == 200) {
            inIsProcessing.add(false);
            Toast.show("Marked failed successfully!", event.context!,
                backgroundColor: primary, gravity: Toast.bottom, duration: 2);
            // ScaffoldMessenger.of(event.context!).showSnackBar(
            //     const SnackBar(content: Text("Marked failed successfully!")));
            Navigator.of(event.context!).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }
      }
      if (event is RetryPickupEvent) {
        Response? response = await HttpService().retryPickupService(
          applicationId: event.applicationId,
        );

        if (response != null) {
          if (response.statusCode == 200) {
            inIsProcessing.add(false);
            Toast.show("Success!", event.context!,
                gravity: Toast.bottom, backgroundColor: primary, duration: 2);
            // ScaffoldMessenger.of(event.context!)
            //     .showSnackBar(const SnackBar(content: Text("Success!")));
            Navigator.of(event.context!).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else {
            // ScaffoldMessenger.of(event.context!)
            //     .showSnackBar(const SnackBar(content: Text("Failed!")));
          }
        }
      }
    });
  }
}
