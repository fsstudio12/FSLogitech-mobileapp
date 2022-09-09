// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:nova/core/enums/notificationEnum.dart';

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
    this.notifications,
    this.unreadCount = 0,
  });

  bool? success;
  TodayOrders? todayOrders;
  List<MonthOrder>? monthOrders;
  List<InAppNotification>? notifications;
  int unreadCount;

  factory CalendarResponseModel.fromJson(Map<String, dynamic> json) =>
      CalendarResponseModel(
        success: json["success"],
        todayOrders: json["todayOrders"] == null
            ? null
            : TodayOrders.fromJson(json["todayOrders"]),
        monthOrders: List<MonthOrder>.from(
          json["monthOrders"].map(
            (x) => MonthOrder.fromJson(x),
          ),
        ),
        notifications: List<InAppNotification>.from(
          json["notifications"].map(
            (x) => InAppNotification.fromJson(x),
          ),
        ),
        unreadCount: json['unReadCount']
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "todayOrders": todayOrders!.toJson(),
        "monthOrders": List<dynamic>.from(monthOrders!.map((x) => x.toJson())),
      };
}

class MonthOrder {
  MonthOrder({
    this.orders,
    this.successfulOrdersCount,
    this.failedOrdersCount,
    this.startDate,
    this.endDate,
  });

  List<Order>? orders;
  num? successfulOrdersCount;

  num? failedOrdersCount;
  DateTime? startDate;
  DateTime? endDate;

  factory MonthOrder.fromJson(Map<String, dynamic> json) => MonthOrder(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        successfulOrdersCount: json["successfulOrdersCount"],
        failedOrdersCount: json["failedOrdersCount"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
        "successfulOrdersCount": successfulOrdersCount,
        "failedOrdersCount": failedOrdersCount,
        "startDate": startDate!.toIso8601String(),
        "endDate": endDate!.toIso8601String(),
      };
}

class Order {
  Order(
      {this.orderId,
      this.userId,
      this.status,
      this.needCutlery,
      this.delivery,
      this.note,
      this.payment,
      this.items,
      this.combos,
      this.createdAt,
      this.foods});

  String? orderId;
  String? userId;
  String? status;
  bool? needCutlery;
  Delivery? delivery;
  String? note;
  Payment? payment;
  Combos? items;
  Combos? combos;
  List<Combos>? foods;
  DateTime? createdAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        userId: json["userId"],
        status: json["status"],
        needCutlery: json["needCutlery"],
        delivery: json["delivery"] == null
            ? null
            : Delivery.fromJson(json["delivery"]),
        note: json["note"],
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        items: json["items"] == null ? null : Combos.fromJson(json["items"]),
        foods: json["foods"] == null
            ? null
            : List<Combos>.from(json["foods"].map((x) => Combos.fromJson(x))),
        combos: json["combos"] == null ? null : Combos.fromJson(json["combos"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
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
        "foods": foods,
        "createdAt": createdAt!.toIso8601String(),
      };
}

class Delivery {
  Delivery({this.location, this.charge, this.riderId, this.failReason});

  Location? location;
  num? charge;
  String? riderId;
  String? failReason;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
      location: Location.fromJson(json["location"]),
      charge: json["charge"],
      riderId: json["riderId"],
      failReason: json["failReason"]);

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "charge": charge,
        "riderId": riderId,
        "failReason": failReason
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

class Combos {
  Combos({
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

  factory Combos.fromJson(Map<String, dynamic> json) => Combos(
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
  Payment(
      {this.subTotal,
      this.discount,
      this.total,
      this.method,
      this.taxes,
      this.txnId,
      this.isPaid,
      this.userName,
      this.userPhone});

  num? subTotal;
  num? discount;
  bool? isPaid;
  num? total;
  String? method;
  String? txnId;
  String? userName;
  String? userPhone;
  List<Tax>? taxes;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        subTotal: json["subTotal"],
        discount: json["discount"],
        isPaid: json["isPaid"],
        total: json["total"],
        method: json["method"] == null ? null : json["method"],
        txnId: json["txnId"] == null ? null : json["txnId"],
        userName: json["userName"] == null ? null : json["userName"],
        userPhone: json["userPhone"] == null ? null : json["userPhone"],
        taxes: json["taxes"] == null
            ? null
            : List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subTotal": subTotal,
        "discount": discount,
        "isPaid": isPaid,
        "total": total,
        "method": method == null ? null : method,
        "txnId": txnId == null ? null : txnId,
        "userName": userName == null ? null : userName,
        "userPhone": userPhone == null ? null : userPhone,
        "taxes": taxes == null
            ? null
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
      };
}

class Tax {
  Tax({
    this.name,
    this.type,
    this.amount,
    this.symbol,
    this.taxableAmount,
  });

  String? name;
  String? type;
  num? amount;
  String? symbol;
  num? taxableAmount;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        name: json["name"],
        type: json["type"],
        amount: json["amount"],
        symbol: json["symbol"],
        taxableAmount: json["taxableAmount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "amount": amount,
        "symbol": symbol,
        "taxableAmount": taxableAmount,
      };
}

class TodayOrders {
  TodayOrders({
    this.ongoing,
    this.pending,
    this.completed,
    this.failed,
  });

  List<Order>? ongoing;
  List<Order>? pending;
  List<Order>? completed;
  List<Order>? failed;

  factory TodayOrders.fromJson(Map<String, dynamic> json) => TodayOrders(
        ongoing:
            List<Order>.from(json["Ongoing"].map((x) => Order.fromJson(x))),
        pending: json["Pending"] == null
            ? null
            : List<Order>.from(json["Pending"].map((x) => Order.fromJson(x))),
        completed:
            List<Order>.from(json["Completed"].map((x) => Order.fromJson(x))),
        failed: List<Order>.from(json["Failed"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Ongoing": List<dynamic>.from(ongoing!.map((x) => x.toJson())),
        "Pending": List<dynamic>.from(pending!.map((x) => x.toJson())),
        "Completed": List<dynamic>.from(completed!.map((x) => x.toJson())),
        "Failed": List<dynamic>.from(failed!.map((x) => x.toJson())),
      };
}

class InAppNotification {
  final NotificationType notificationType;
  final String notificationId;
  final String entityId;
  final String title;
  final DateTime createdAt;
  final String body;
  final bool isRead;

  InAppNotification(
      {this.notificationType = NotificationType.Delivery,
      required this.notificationId,
      required this.entityId,
      required this.title,
      required this.createdAt,
      required this.body,
      required this.isRead});

  factory InAppNotification.fromJson(Map<String, dynamic> json) =>
      InAppNotification(
        notificationId: json['notificationId'],
        entityId: json['entityId'],
        title: json['title'],
        createdAt: DateTime.parse(json['createdAt']),
        body: json['body'],
        isRead: json['isRead'],
      );
}

// class Completed {
//   Completed({
//     this.orderId,
//     this.needCutlery,
//     this.delivery,
//     this.note,
//     this.createdAt,
//   });

//   String? orderId;
//   bool? needCutlery;
//   Delivery? delivery;
//   String? note;
//   DateTime? createdAt;

//   factory Completed.fromJson(Map<String, dynamic> json) => Completed(
//         orderId: json["orderId"],
//         needCutlery: json["needCutlery"] == null ? null : json["needCutlery"],
//         delivery: Delivery.fromJson(json["delivery"]),
//         note: json["note"],
//         createdAt: DateTime.parse(json["createdAt"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "orderId": orderId,
//         "needCutlery": needCutlery == null ? null : needCutlery,
//         "delivery": delivery!.toJson(),
//         "note": note,
//         "createdAt": createdAt!.toIso8601String(),
//       };
// }
