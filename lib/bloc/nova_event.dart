part of 'nova_bloc.dart';

// @immutable
abstract class NovaEvent {}

class LoginEvent extends NovaEvent {
  String? phoneNumber;
  String? password;
  BuildContext? context;
  LoginEvent({this.password, this.phoneNumber, this.context});
}

class GetTodaysStatusEvent extends NovaEvent {
  RefreshController? refreshController;
  GetTodaysStatusEvent({this.refreshController});
}

class GetCalendarEvent extends NovaEvent {
  RefreshController? refreshController;
  GetCalendarEvent({this.refreshController});
}

class GetPickupDetailEvent extends NovaEvent {
  String? id;
  GetPickupDetailEvent({this.id});
}

class StartPickupEvent extends NovaEvent {
  String? applicationId;
  Uint8List? signature;
  List<Uint8List>? proofImages;
  BuildContext? context;
  List<Product>? products;
  StartPickupEvent(
      {this.applicationId,
      this.proofImages,
      this.signature,
      this.context,
      this.products});
}

class MarkFailedEvent extends NovaEvent {
  String? applicationId;
  String? reason;
  BuildContext? context;
  MarkFailedEvent({this.applicationId, this.context, this.reason});
}

class RetryPickupEvent extends NovaEvent {
  String? applicationId;

  BuildContext? context;
  RetryPickupEvent({
    this.applicationId,
    this.context,
  });
}
