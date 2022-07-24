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

  final StreamController<List<String>>
      _selectedPendingOrdersIdsListStreamController = BehaviorSubject();
  Stream<List<String>> get outSelectedPendingOrdersIdsList =>
      _selectedPendingOrdersIdsListStreamController.stream;
  Sink<List<String>> get inSelectedPendingOrdersIdsList =>
      _selectedPendingOrdersIdsListStreamController.sink;

  final StreamController<bool> _isProcessing = BehaviorSubject();
  Stream<bool> get outIsProcessing => _isProcessing.stream;
  Sink<bool> get inIsProcessing => _isProcessing.sink;

  final StreamController<bool> _selectAllPendingDeliveries = BehaviorSubject();
  Stream<bool> get outSelectAllPendingDeliveries =>
      _selectAllPendingDeliveries.stream;
  Sink<bool> get inSelectAllPendingDeliveries =>
      _selectAllPendingDeliveries.sink;

  final StreamController<String> _selectedPaymentMethodFromDropdown =
      BehaviorSubject();
  Stream<String> get outSelectedPaymentMethodFromDropdown =>
      _selectedPaymentMethodFromDropdown.stream;
  Sink<String> get inSelectedPaymentMethodFromDropdown =>
      _selectedPaymentMethodFromDropdown.sink;

  final StreamController<Uint8List> _proofImage = BehaviorSubject();
  Stream<Uint8List> get outProofImage => _proofImage.stream;
  Sink<Uint8List> get inProofImage => _proofImage.sink;

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

      if (event is StartDeliveryEvent) {
        Response? response =
            await HttpService().startDelivery(orderIds: event.orderIds);

        if (response != null) {
          if (response.statusCode == 200) {
            Toast.show("Delivery Started successfully!", event.context!,
                backgroundColor: primary, gravity: Toast.bottom, duration: 2);
            Navigator.of(event.context!).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }
      }

      if (event is CompleteDeliveryEvent) {
        Response? response = await HttpService().completeDeliveryService(
            orderId: event.orderId, image: event.image, method: event.method);

        if (response != null) {
          if (response.statusCode == 200) {
            Toast.show("Delivery Completed successfully!", event.context!,
                backgroundColor: primary, gravity: Toast.bottom, duration: 2);
            Navigator.of(event.context!).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }
      }

      if (event is MarkFailedEvent) {
        Response? response = await HttpService()
            .markFailedService(orderId: event.orderId, reason: event.reason);

        if (response != null) {
          if (response.statusCode == 200) {
            inIsProcessing.add(false);

            // ScaffoldMessenger.of(event.context!).showSnackBar(
            //     const SnackBar(content: Text("Marked failed successfully!")));
            Navigator.of(event.context!).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }
      }
    });
  }
}
