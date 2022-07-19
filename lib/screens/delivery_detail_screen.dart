import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:nova/bloc/nova_bloc.dart';
import 'package:nova/models/nova_model.dart';
import 'package:nova/screens/image_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import 'start_delivery_screen.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final Order order;
  const DeliveryDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  NovaBloc novaBloc = NovaBloc();
  TextEditingController markFailedController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text("#${widget.order.orderId}"),
          elevation: 0,
          actions: [
            widget.order.status == "ongoing"
                ? PopupMenuButton<Popme>(
                    onSelected: (Popme result) async {
                      if (result == Popme.call) {
                        await launchUrl(Uri.parse(
                            "tel://${widget.order.delivery!.location!.phone!}"));
                      } else if (result == Popme.navigate) {
                        if (await canLaunchUrl(Uri.parse(
                            "$mapUrl&query=${widget.order.delivery!.location!.latitude},${widget.order.delivery!.location!.longitude}"))) {
                          await launchUrl(Uri.parse(
                              "$mapUrl&query=${widget.order.delivery!.location!.latitude},${widget.order.delivery!.location!.longitude}"));
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text("Mark as failed?"),
                                content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Reason"),
                                      TextField(
                                        controller: markFailedController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      )
                                    ]),
                                actions: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          // width: 5.0,
                                          color: secondary),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: secondary),
                                    ),
                                  ),
                                  MaterialButton(
                                    color: secondary,
                                    onPressed: () {
                                      novaBloc.add(MarkFailedEvent(
                                          context: context,
                                          orderId: widget.order.orderId,
                                          reason: markFailedController.text));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Proceed",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Popme>>[
                      const PopupMenuItem<Popme>(
                        value: Popme.call,
                        child: Text('Call'),
                      ),
                      const PopupMenuItem<Popme>(
                        value: Popme.navigate,
                        child: Text('Navigate'),
                      ),
                      const PopupMenuItem<Popme>(
                        value: Popme.markfailed,
                        child: Text('Mark as Failed'),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            PhosphorIcons.clock,
                            size: 15,
                            color: darkGray,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              AppConfig()
                                  .timeFormat
                                  .format(widget.order.createdAt!),
                              style: const TextStyle(
                                  color: darkGray, fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: widget.order.status == "Pending"
                                    ? pending
                                    : widget.order.status == "Ongoing"
                                        ? processing
                                        : widget.order.status == "Completed"
                                            ? completed
                                            : failed),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          child: Text(
                            widget.order.status.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: widget.order.status == "Pending"
                                    ? pending
                                    : widget.order.status == "Ongoing"
                                        ? processing
                                        : widget.order.status == "Completed"
                                            ? completed
                                            : failed),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.order.status == "Failed"
                      ? widget.order.delivery!.failReason != null
                          ? Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 15),
                                  child: Text(
                                    "Reason",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text(
                                  widget.order.delivery!.failReason!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            )
                          : Container()
                      : Container(),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 15),
                    child: Text(
                      "Customer Details",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: pale),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.order.delivery!.location!.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              widget.order.delivery!.location!.phone!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            widget.order.delivery!.location!.address!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 15),
                    child: Text(
                      "Items",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Column(
                    children:
                        List.generate(widget.order.foods!.length, (foodsIndex) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: pale),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Image.network(
                                  widget.order.foods![foodsIndex].image!,
                                  height: 50,
                                  width: 50),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.foods![foodsIndex].name!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Text(
                                        "Qty: ${widget.order.foods![foodsIndex].quantity!}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Rs. ${widget.order.foods![foodsIndex].price!}",
                                      style: const TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: widget.order.status == "Pending"
                      ? MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          color: secondary,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "Start delivery process",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          onPressed: () {
                            novaBloc.add(StartDeliveryEvent(
                                context: context,
                                orderIds: [widget.order.orderId]));
                          })
                      : Container())
            ],
          ),
        ));
  }
}
