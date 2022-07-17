// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'nova_model.g.dart';

// LoginResponseModel loginResponseModelFromJson(String str) =>
//     LoginResponseModel.fromJson(json.decode(str));

// String loginResponseModelToJson(LoginResponseModel data) =>
//     json.encode(data.toJson());

// @HiveType(typeId: 0)
// class LoginResponseModel extends HiveObject {
//   LoginResponseModel({
//     this.success,
//     this.userId,
//     this.image,
//     this.name,
//     this.role,
//     this.token,
//   });

//   bool? success;
//   @HiveField(0)
//   String? userId;
//   @HiveField(1)
//   dynamic image;
//   @HiveField(2)
//   String? name;
//   @HiveField(3)
//   String? role;
//   @HiveField(4)
//   String? token;

//   factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
//       LoginResponseModel(
//         success: json["success"],
//         userId: json["userId"],
//         image: json["image"],
//         name: json["name"],
//         role: json["role"],
//         token: json["token"],
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "userId": userId,
//         "image": image,
//         "name": name,
//         "role": role,
//         "token": token,
//       };
// }

// To parse this JSON data, do
//
//     final todaysStatusResponseModel = todaysStatusResponseModelFromJson(jsonString);

TodaysStatusResponseModel todaysStatusResponseModelFromJson(String str) =>
    TodaysStatusResponseModel.fromJson(json.decode(str));

String todaysStatusResponseModelToJson(TodaysStatusResponseModel data) =>
    json.encode(data.toJson());

class TodaysStatusResponseModel {
  TodaysStatusResponseModel(
      {this.success,
      this.ongoing,
      this.pending,
      this.completed,
      this.failed,
      this.calendar});

  bool? success;
  List? ongoing;
  List? pending;
  List? completed;
  List? failed;
  List<Calendar>? calendar;

  factory TodaysStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      TodaysStatusResponseModel(
        success: json["success"],
        ongoing: json["ongoing"].isNotEmpty
            ? List<Pickup>.from(json["ongoing"].map((x) => Pickup.fromJson(x)))
            : List<dynamic>.from(json["ongoing"].map((x) => x)),
        pending: json["pending"].isNotEmpty
            ? List<Pickup>.from(json["pending"].map((x) => Pickup.fromJson(x)))
            : List<dynamic>.from(json["pending"].map((x) => x)),
        completed: json["completed"].isNotEmpty
            ? List<Pickup>.from(
                json["completed"].map((x) => Pickup.fromJson(x)))
            : List<dynamic>.from(json["completed"].map((x) => x)),
        failed: json["failed"].isNotEmpty
            ? List<Pickup>.from(json["failed"].map((x) => Pickup.fromJson(x)))
            : List<dynamic>.from(json["failed"].map((x) => x)),
        calendar: List<Calendar>.from(
            json["calendar"].map((x) => Calendar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "ongoing": List<dynamic>.from(ongoing!.map((x) => x.toJson())),
        "pending": List<dynamic>.from(pending!.map((x) => x.toJson())),
        "completed": List<dynamic>.from(completed!.map((x) => x)),
        "failed": List<dynamic>.from(failed!.map((x) => x.toJson())),
        "calendar": List<dynamic>.from(calendar!.map((x) => x.toJson())),
      };
}

class Calendar {
  Calendar({
    this.date,
    this.pickups,
  });

  DateTime? date;
  List<Pickup>? pickups;

  factory Calendar.fromJson(Map<String, dynamic> json) => Calendar(
        date: DateTime.parse(json["date"]),
        pickups:
            List<Pickup>.from(json["pickups"].map((x) => Pickup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date!.toIso8601String(),
        "pickups": List<dynamic>.from(pickups!.map((x) => x.toJson())),
      };
}

class Farmer {
  Farmer({
    this.name,
    this.phoneNumber,
    this.image,
  });

  String? name;
  String? phoneNumber;
  String? image;

  factory Farmer.fromJson(Map<String, dynamic> json) => Farmer(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "image": image,
      };
}

// To parse this JSON data, do
//
//     final pickupDetailResponseModel = pickupDetailResponseModelFromJson(jsonString);

PickupDetailResponseModel pickupDetailResponseModelFromJson(String str) =>
    PickupDetailResponseModel.fromJson(json.decode(str));

String pickupDetailResponseModelToJson(PickupDetailResponseModel data) =>
    json.encode(data.toJson());

class PickupDetailResponseModel {
  PickupDetailResponseModel({
    this.success,
    this.application,
  });

  bool? success;
  List<Application>? application;

  factory PickupDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      PickupDetailResponseModel(
        success: json["success"],
        application: List<Application>.from(
            json["application"].map((x) => Application.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "application": List<dynamic>.from(application!.map((x) => x.toJson())),
      };
}

class Application {
  Application({
    this.id,
    this.status,
    this.products,
    this.applicationId,
    this.adminPickUpDate,
    this.adminPickUpLocationAlt,
    this.adminPickUpLocationString,
    this.farmer,
    this.reason,
    this.proofOfPickup,
    this.signature,
  });

  String? id;
  String? status;
  List<Product>? products;
  num? applicationId;
  DateTime? adminPickUpDate;
  String? adminPickUpLocationAlt;
  String? adminPickUpLocationString;
  Farmer? farmer;
  dynamic reason;
  List<ProofOfPickup>? proofOfPickup;
  ProofOfPickup? signature;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        id: json["_id"],
        status: json["status"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        applicationId: json["applicationId"],
        adminPickUpDate: DateTime.parse(json["adminPickUpDate"]),
        adminPickUpLocationAlt: json["adminPickUpLocationAlt"],
        adminPickUpLocationString: json["adminPickUpLocationString"],
        farmer: Farmer.fromJson(json["farmer"]),
        reason: json["reason"] == null ? null : json["reason"],
        proofOfPickup: json["proofOfPickup"] == null
            ? null
            : List<ProofOfPickup>.from(
                json["proofOfPickup"].map((x) => ProofOfPickup.fromJson(x))),
        signature: json["signature"] == null
            ? null
            : ProofOfPickup.fromJson(json["signature"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "applicationId": applicationId,
        "adminPickUpDate": adminPickUpDate!.toIso8601String(),
        "adminPickUpLocationAlt": adminPickUpLocationAlt,
        "adminPickUpLocationString": adminPickUpLocationString,
        "farmer": farmer!.toJson(),
        "reason": reason,
        "proofOfPickup": proofOfPickup == null
            ? null
            : List<dynamic>.from(proofOfPickup!.map((x) => x.toJson())),
        "signature": signature == null ? null : signature,
      };
}

class Product {
  Product({
    this.productId,
    this.images,
    this.adminEstimatedPrice,
    this.adminQuantity,
    this.adminQuantityUnit,
    this.productName,
  });

  String? productId;
  List<ProofOfPickup>? images;
  num? adminEstimatedPrice;
  num? adminQuantity;
  String? adminQuantityUnit;
  String? productName;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        images: List<ProofOfPickup>.from(
            json["images"].map((x) => ProofOfPickup.fromJson(x))),
        adminEstimatedPrice: json["adminEstimatedPrice"],
        adminQuantity: json["adminQuantity"],
        adminQuantityUnit: json["adminQuantityUnit"],
        productName: json["productName"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "adminEstimatedPrice": adminEstimatedPrice,
        "adminQuantity": adminQuantity,
        "adminQuantityUnit": adminQuantityUnit,
        "productName": productName,
      };
}

class ProofOfPickup {
  ProofOfPickup({
    this.imageKey,
    this.imageUrl,
  });

  String? imageKey;
  String? imageUrl;

  factory ProofOfPickup.fromJson(Map<String, dynamic> json) => ProofOfPickup(
        imageKey: json["imageKey"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "imageKey": imageKey,
        "imageUrl": imageUrl,
      };
}

// CalendarDetailResponseModel calendarDetailResponseModelFromJson(String str) =>
//     CalendarDetailResponseModel.fromJson(json.decode(str));

// String calendarDetailResponseModelToJson(CalendarDetailResponseModel data) =>
//     json.encode(data.toJson());

// class CalendarDetailResponseModel {
//   CalendarDetailResponseModel({
//     this.success,
//     this.data,
//   });

//   bool? success;
//   List<Datum>? data;

//   factory CalendarDetailResponseModel.fromJson(Map<String, dynamic> json) =>
//       CalendarDetailResponseModel(
//         success: json["success"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   Datum({
//     this.date,
//     this.pickups,
//   });

//   DateTime? date;
//   List<Pickup>? pickups;

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         date: DateTime.parse(json["date"]),
//         pickups:
//             List<Pickup>.from(json["pickups"].map((x) => Pickup.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "date": date!.toIso8601String(),
//         "pickups": List<dynamic>.from(pickups!.map((x) => x.toJson())),
//       };
// }

class Pickup {
  Pickup({
    this.id,
    this.applicationId,
    this.adminPickUpDate,
    this.adminPickUpLocationAlt,
    this.adminPickUpLocationString,
    this.reason,
    this.farmer,
    this.status,
  });

  String? id;
  num? applicationId;
  DateTime? adminPickUpDate;
  String? adminPickUpLocationAlt;
  String? adminPickUpLocationString;
  dynamic reason;
  Farmer? farmer;
  String? status;

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
        id: json["_id"],
        applicationId: json["applicationId"],
        adminPickUpDate: DateTime.parse(json["adminPickUpDate"]),
        adminPickUpLocationAlt: json["adminPickUpLocationAlt"],
        adminPickUpLocationString: json["adminPickUpLocationString"],
        reason: json["reason"],
        farmer: Farmer.fromJson(json["farmer"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "applicationId": applicationId,
        "adminPickUpDate": adminPickUpDate!.toIso8601String(),
        "adminPickUpLocationAlt": adminPickUpLocationAlt,
        "adminPickUpLocationString": adminPickUpLocationString,
        "reason": reason,
        "farmer": farmer!.toJson(),
        "status": status,
      };
}

//for ongoing pickup pop up

enum Popme { call, navigate, markfailed }

//
//
///
/////
///
///
///
///
///
//for fs logitech

// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    this.success,
    this.data,
  });

  bool? success;

  UserData? data;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        success: json["success"],
        data: UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
      };
}

@HiveType(typeId: 0)
class UserData extends HiveObject {
  UserData({
    this.jwtToken,
    this.employeeId,
    this.image,
    this.name,
    this.email,
    this.phone,
  });

  @HiveField(0)
  String? jwtToken;
  @HiveField(1)
  String? employeeId;
  @HiveField(2)
  String? image;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? email;
  @HiveField(5)
  String? phone;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        jwtToken: json["jwtToken"],
        employeeId: json["employeeId"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "jwtToken": jwtToken,
        "employeeId": employeeId,
        "image": image,
        "name": name,
        "email": email,
        "phone": phone,
      };
}

// To parse this JSON data, do
//
//     final allPickupsResponseModel = allPickupsResponseModelFromJson(jsonString);

AllPickupsResponseModel allPickupsResponseModelFromJson(String str) =>
    AllPickupsResponseModel.fromJson(json.decode(str));

String allPickupsResponseModelToJson(AllPickupsResponseModel data) =>
    json.encode(data.toJson());

class AllPickupsResponseModel {
  AllPickupsResponseModel({
    this.success,
    this.orders,
  });

  bool? success;
  Orders? orders;

  factory AllPickupsResponseModel.fromJson(Map<String, dynamic> json) =>
      AllPickupsResponseModel(
        success: json["success"],
        orders: Orders.fromJson(json["orders"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "orders": orders!.toJson(),
      };
}

class Orders {
  Orders({
    this.ongoing,
    this.pending,
    this.completed,
    this.failed,
  });

  List<Ongoing>? ongoing;
  List<Ongoing>? pending;
  List<Ongoing>? completed;
  List<Ongoing>? failed;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        ongoing:
            List<Ongoing>.from(json["Ongoing"].map((x) => Ongoing.fromJson(x))),
        pending:
            List<Ongoing>.from(json["Pending"].map((x) => Ongoing.fromJson(x))),
        completed: List<Ongoing>.from(
            json["Completed"].map((x) => Ongoing.fromJson(x))),
        failed:
            List<Ongoing>.from(json["Failed"].map((x) => Ongoing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Ongoing": List<dynamic>.from(ongoing!.map((x) => x.toJson())),
        "Pending": List<dynamic>.from(pending!.map((x) => x.toJson())),
        "Completed": List<dynamic>.from(completed!.map((x) => x.toJson())),
        "Failed": List<dynamic>.from(failed!.map((x) => x.toJson())),
      };
}

class Ongoing {
  Ongoing({
    this.orderId,
    this.needCutlery,
    this.delivery,
    this.note,
    this.createdAt,
  });

  String? orderId;
  bool? needCutlery;
  Delivery? delivery;
  String? note;
  DateTime? createdAt;

  factory Ongoing.fromJson(Map<String, dynamic> json) => Ongoing(
        orderId: json["orderId"],
        needCutlery: json["needCutlery"] == null ? null : json["needCutlery"],
        delivery: Delivery.fromJson(json["delivery"]),
        note: json["note"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "needCutlery": needCutlery == null ? null : needCutlery,
        "delivery": delivery!.toJson(),
        "note": note,
        "createdAt": createdAt!.toIso8601String(),
      };
}

class Delivery {
  Delivery({
    this.location,
    this.charge,
    this.riderId,
  });

  Location? location;
  num? charge;
  String? riderId;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        location: Location.fromJson(json["location"]),
        charge: json["charge"],
        riderId: json["riderId"],
      );

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "charge": charge,
        "riderId": riderId,
      };
}

class Location {
  Location(
      {this.title,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.latitude,
      this.longitude,
      this.image});

  String? title;
  String? image;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? latitude;
  String? longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        title: json["title"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "title": title, 
        "image": image,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}

// To parse this JSON data, do
//
//     final calendarResponseModel = calendarResponseModelFromJson(jsonString);

CalendarResponseModel calendarResponseModelFromJson(String str) =>
    CalendarResponseModel.fromJson(json.decode(str));

String calendarResponseModelToJson(CalendarResponseModel data) =>
    json.encode(data.toJson());

class CalendarResponseModel {
  CalendarResponseModel({
    this.success,
    this.todayOrders,
    this.monthOrders,
  });

  bool? success;
  TodayOrders? todayOrders;
  List<MonthOrder>? monthOrders;

  factory CalendarResponseModel.fromJson(Map<String, dynamic> json) =>
      CalendarResponseModel(
        success: json["success"],
        todayOrders: TodayOrders.fromJson(json["todayOrders"]),
        monthOrders: List<MonthOrder>.from(
            json["monthOrders"].map((x) => MonthOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "todayOrders": todayOrders!.toJson(),
        "monthOrders": List<dynamic>.from(monthOrders!.map((x) => x.toJson())),
      };
}

class MonthOrder {
  MonthOrder({
    this.successfulOrders,
    this.successfulOrdersCount,
    this.failedOrders,
    this.failedOrdersCount,
    this.startDate,
    this.endDate,
  });

  List<SuccessfulOrder>? successfulOrders;
  num? successfulOrdersCount;
  List<FailedOrder>? failedOrders;
  num? failedOrdersCount;
  DateTime? startDate;
  DateTime? endDate;

  factory MonthOrder.fromJson(Map<String, dynamic> json) => MonthOrder(
        successfulOrders: List<SuccessfulOrder>.from(
            json["successfulOrders"].map((x) => SuccessfulOrder.fromJson(x))),
        successfulOrdersCount: json["successfulOrdersCount"],
        failedOrders: List<FailedOrder>.from(
            json["failedOrders"].map((x) => FailedOrder.fromJson(x))),
        failedOrdersCount: json["failedOrdersCount"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "successfulOrders":
            List<dynamic>.from(successfulOrders!.map((x) => x.toJson())),
        "successfulOrdersCount": successfulOrdersCount,
        "failedOrders":
            List<dynamic>.from(failedOrders!.map((x) => x.toJson())),
        "failedOrdersCount": failedOrdersCount,
        "startDate": startDate!.toIso8601String(),
        "endDate": endDate!.toIso8601String(),
      };
}

class FailedOrder {
  FailedOrder({
    this.orderId,
    this.userId,
    this.status,
    this.needCutlery,
    this.delivery,
    this.note,
    this.payment,
    this.items,
    this.combos,
    this.createdAt,
  });

  String? orderId;
  String? userId;
  String? status;
  bool? needCutlery;
  Delivery? delivery;
  String? note;
  Payment? payment;
  ItemsClass? items;
  ItemsClass? combos;
  DateTime? createdAt;

  factory FailedOrder.fromJson(Map<String, dynamic> json) => FailedOrder(
        orderId: json["orderId"],
        userId: json["userId"],
        status: json["status"],
        needCutlery: json["needCutlery"],
        delivery: Delivery.fromJson(json["delivery"]),
        note: json["note"],
        payment: Payment.fromJson(json["payment"]),
        items: ItemsClass.fromJson(json["items"]),
        combos: ItemsClass.fromJson(json["combos"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "status": status,
        "needCutlery": needCutlery,
        "delivery": delivery!.toJson(),
        "note": note,
        "payment": payment!.toJson(),
        "items": items!.toJson(),
        "combos": combos!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
      };
}

class ItemsClass {
  ItemsClass({
    this.comboId,
    this.name,
    this.image,
    this.quantity,
    this.spiceLevel,
    this.price,
    this.itemId,
  });

  String? comboId;
  String? name;
  String? image;
  num? quantity;
  String? spiceLevel;
  num? price;
  String? itemId;

  factory ItemsClass.fromJson(Map<String, dynamic> json) => ItemsClass(
        comboId: json["comboId"] == null ? null : json["comboId"],
        name: json["name"],
        image: json["image"],
        quantity: json["quantity"],
        spiceLevel: json["spiceLevel"],
        price: json["price"],
        itemId: json["itemId"] == null ? null : json["itemId"],
      );

  Map<String, dynamic> toJson() => {
        "comboId": comboId == null ? null : comboId,
        "name": name,
        "image": image,
        "quantity": quantity,
        "spiceLevel": spiceLevel,
        "price": price,
        "itemId": itemId == null ? null : itemId,
      };
}

class Payment {
  Payment({
    this.subTotal,
    this.discount,
    this.total,
  });

  num? subTotal;
  num? discount;
  num? total;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        subTotal: json["subTotal"],
        discount: json["discount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "subTotal": subTotal,
        "discount": discount,
        "total": total,
      };
}

class SuccessfulOrder {
  SuccessfulOrder({
    this.orderId,
    this.userId,
    this.status,
    this.needCutlery,
    this.delivery,
    this.note,
    this.payment,
    this.items,
    this.combos,
    this.createdAt,
  });

  String? orderId;
  String? userId;
  String? status;
  bool? needCutlery;
  Delivery? delivery;
  String? note;
  Payment? payment;
  ItemsClass? items;
  ItemsClass? combos;
  DateTime? createdAt;

  factory SuccessfulOrder.fromJson(Map<String, dynamic> json) =>
      SuccessfulOrder(
        orderId: json["orderId"],
        userId: json["userId"],
        status: json["status"],
        needCutlery: json["needCutlery"],
        delivery: Delivery.fromJson(json["delivery"]),
        note: json["note"],
        payment: Payment.fromJson(json["payment"]),
        items: ItemsClass.fromJson(json["items"]),
        combos: ItemsClass.fromJson(json["combos"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "status": status,
        "needCutlery": needCutlery,
        "delivery": delivery!.toJson(),
        "note": note,
        "payment": payment!.toJson(),
        "items": items!.toJson(),
        "combos": combos!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
      };
}

class PurpleCombos {
  PurpleCombos();

  factory PurpleCombos.fromJson(Map<String, dynamic> json) => PurpleCombos();

  Map<String, dynamic> toJson() => {};
}

class TodayOrders {
  TodayOrders({
    this.ongoing,
    this.pending,
    this.completed,
    this.failed,
  });

  List<Completed>? ongoing;
  List<Completed>? pending;
  List<Completed>? completed;
  List<Completed>? failed;

  factory TodayOrders.fromJson(Map<String, dynamic> json) => TodayOrders(
        ongoing: List<Completed>.from(
            json["Ongoing"].map((x) => Completed.fromJson(x))),
        pending: List<Completed>.from(
            json["Pending"].map((x) => Completed.fromJson(x))),
        completed: List<Completed>.from(
            json["Completed"].map((x) => Completed.fromJson(x))),
        failed: List<Completed>.from(
            json["Failed"].map((x) => Completed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Ongoing": List<dynamic>.from(ongoing!.map((x) => x.toJson())),
        "Pending": List<dynamic>.from(pending!.map((x) => x.toJson())),
        "Completed": List<dynamic>.from(completed!.map((x) => x.toJson())),
        "Failed": List<dynamic>.from(failed!.map((x) => x.toJson())),
      };
}

class Completed {
  Completed({
    this.orderId,
    this.needCutlery,
    this.delivery,
    this.note,
    this.createdAt,
  });

  String? orderId;
  bool? needCutlery;
  Delivery? delivery;
  String? note;
  DateTime? createdAt;

  factory Completed.fromJson(Map<String, dynamic> json) => Completed(
        orderId: json["orderId"],
        needCutlery: json["needCutlery"] == null ? null : json["needCutlery"],
        delivery: Delivery.fromJson(json["delivery"]),
        note: json["note"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "needCutlery": needCutlery == null ? null : needCutlery,
        "delivery": delivery!.toJson(),
        "note": note,
        "createdAt": createdAt!.toIso8601String(),
      };
}
