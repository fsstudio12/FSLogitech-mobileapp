part of 'nova_bloc.dart';

// @immutable
abstract class NovaEvent {}

class LoginEvent extends NovaEvent {
  String? phoneNumber;
  String? password;
  BuildContext? context;
  LoginEvent({this.password, this.phoneNumber, this.context});
}

class GetCalendarEvent extends NovaEvent {
  RefreshController? refreshController;
  GetCalendarEvent({this.refreshController});
}

class StartDeliveryEvent extends NovaEvent {
  List? orderIds;
  BuildContext? context;
  StartDeliveryEvent({this.orderIds, this.context});
}

class MarkFailedEvent extends NovaEvent {
  String? orderId;
  String? reason;
  BuildContext? context;
  MarkFailedEvent({this.orderId, this.context, this.reason});
}

class CompleteDeliveryEvent extends NovaEvent {
  String? orderId;
  Uint8List? image;
  String? method;

  BuildContext? context;
  CompleteDeliveryEvent({this.orderId, this.image, this.context, this.method});
}

class ResetPassword extends NovaEvent {
  BuildContext? context;
  String? email;
  ResetPassword({this.email, this.context});
}






