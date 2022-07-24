import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:nova/bloc/nova_bloc.dart';
import 'package:nova/screens/delivery_detail_screen.dart';
import 'package:nova/screens/start_delivery_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import '../models/nova_model.dart';

class DeliveriesListScreen extends StatefulWidget {
  final List<Order> deliveriesList;
  final String type;

  const DeliveriesListScreen(
      {Key? key, required this.deliveriesList, required this.type})
      : super(key: key);

  @override
  State<DeliveriesListScreen> createState() => _DeliveriesListScreenState();
}

class _DeliveriesListScreenState extends State<DeliveriesListScreen> {
  NovaBloc novaBloc = NovaBloc();
  List<String> orderIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("${widget.type} Deliveries"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
          child: StreamBuilder<List<String>>(
              initialData: orderIds,
              stream: novaBloc.outSelectedPendingOrdersIdsList,
              builder: (context, outSelectedPendingOrdersIndexListSnapshot) {
                orderIds = outSelectedPendingOrdersIndexListSnapshot.data!;
                return Column(
                  children: [
                    widget.type == "Pending"
                        ? Column(
                            children: [
                              outSelectedPendingOrdersIndexListSnapshot
                                      .data!.isEmpty
                                  ? InkWell(
                                      onTap: () {
                                        orderIds = [];
                                        for (var v in widget.deliveriesList) {
                                          orderIds.add(v.orderId!);
                                        }
                                        novaBloc.add(StartDeliveryEvent(
                                            orderIds: orderIds,
                                            context: context));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: primary),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16, bottom: 16),
                                          child: Center(
                                            child: Text(
                                              "Start All At Once",
                                              style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            StreamBuilder<bool>(
                                                initialData: false,
                                                stream: novaBloc
                                                    .outSelectAllPendingDeliveries,
                                                builder: (context,
                                                    outSelectAllPendingDeliveriesSnapshot) {
                                                  return SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: Checkbox(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          value:
                                                              outSelectAllPendingDeliveriesSnapshot
                                                                  .data,
                                                          onChanged: (value) {
                                                            novaBloc
                                                                .inSelectAllPendingDeliveries
                                                                .add(value!);
                                                            if (value) {
                                                              orderIds = [];
                                                              for (var v in widget
                                                                  .deliveriesList) {
                                                                orderIds.add(
                                                                    v.orderId!);
                                                              }
                                                              novaBloc
                                                                  .inSelectedPendingOrdersIdsList
                                                                  .add(
                                                                      orderIds);
                                                            } else {
                                                              orderIds = [];
                                                              novaBloc
                                                                  .inSelectedPendingOrdersIdsList
                                                                  .add(
                                                                      orderIds);
                                                            }
                                                          }));
                                                }),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                "All",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              height: 17,
                                              width: 3,
                                              color: darkGray,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                  " ${orderIds.length} selected",
                                                  style: const TextStyle(
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            novaBloc.add(StartDeliveryEvent(
                                                orderIds: orderIds,
                                                context: context));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: primary),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 7,
                                                  bottom: 7,
                                                  left: 13,
                                                  right: 13),
                                              child: Center(
                                                child: Text(
                                                  "Start Delivery",
                                                  style: TextStyle(
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          )
                        : Container(),
                    Column(
                        children: List.generate(widget.deliveriesList.length,
                            (listIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () {
                            if (widget.type == "Pending") {
                              if (orderIds.contains(
                                  widget.deliveriesList[listIndex].orderId)) {
                                orderIds.remove(
                                    widget.deliveriesList[listIndex].orderId);
                                novaBloc.inSelectAllPendingDeliveries
                                    .add(false);
                              } else {
                                orderIds.add(
                                    widget.deliveriesList[listIndex].orderId!);
                              }
                              novaBloc.inSelectedPendingOrdersIdsList
                                  .add(orderIds);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: orderIds.contains(widget
                                          .deliveriesList[listIndex].orderId)
                                      ? primary
                                      : pale,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "#${widget.deliveriesList[listIndex].orderId}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: link),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: widget
                                                                .deliveriesList[
                                                                    listIndex]
                                                                .status ==
                                                            "Pending"
                                                        ? pending
                                                        : widget
                                                                    .deliveriesList[
                                                                        listIndex]
                                                                    .status ==
                                                                "Completed"
                                                            ? completed
                                                            : widget
                                                                        .deliveriesList[
                                                                            listIndex]
                                                                        .status ==
                                                                    "Ongoing"
                                                                ? processing
                                                                : failed),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              child: Text(
                                                widget.deliveriesList[listIndex]
                                                    .status
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: widget
                                                                .deliveriesList[
                                                                    listIndex]
                                                                .status ==
                                                            "Pending"
                                                        ? pending
                                                        : widget
                                                                    .deliveriesList[
                                                                        listIndex]
                                                                    .status ==
                                                                "Ongoing"
                                                            ? processing
                                                            : widget.deliveriesList[listIndex]
                                                                        .status ==
                                                                    "Completed"
                                                                ? completed
                                                                : failed),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              PhosphorIcons.clock,
                                              color: darkGray,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                AppConfig().timeFormat.format(
                                                    widget
                                                        .deliveriesList[
                                                            listIndex]
                                                        .createdAt!),
                                                style: const TextStyle(
                                                  color: darkGray,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              PhosphorIcons.map_pin,
                                              color: darkGray,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                "${widget.deliveriesList[listIndex].delivery!.location!.address}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          DeliveryDetailScreen(
                                                            order: widget
                                                                    .deliveriesList[
                                                                listIndex],
                                                          ))));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 0,
                                                bottom: 10,
                                              ),
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    "View details",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: link,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Icon(
                                                    PhosphorIcons.caret_right,
                                                    size: 15,
                                                    color: link,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // widget.deliveriesList[listIndex].status == "Pending"
                                      //     ? Padding(
                                      //         padding: const EdgeInsets.only(
                                      //           top: 0,
                                      //           bottom: 10,
                                      //         ),
                                      //         child: InkWell(
                                      //           onTap: () {},
                                      //           // onTap: () => Navigator.of(context).push(
                                      //           //     MaterialPageRoute(
                                      //           //         builder: ((context) =>
                                      //           //             StartPickupScreen(
                                      //           //               pickupId: widget
                                      //           //                   .deliveriesList[listIndex]
                                      //           //                   .id!,
                                      //           //             )))),
                                      //           child: Container(
                                      //             decoration: BoxDecoration(
                                      //                 border: Border.all(color: pending),
                                      //                 borderRadius: BorderRadius.circular(5)),
                                      //             child: const Padding(
                                      //               padding: EdgeInsets.only(
                                      //                   top: 5,
                                      //                   bottom: 5,
                                      //                   left: 10,
                                      //                   right: 10),
                                      //               child: Text(
                                      //                 "Start pickup process",
                                      //                 style: TextStyle(
                                      //                     fontWeight: FontWeight.w700,
                                      //                     color: pending),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                    ],
                                  ),
                                ),
                                const Divider(height: 0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.deliveriesList[listIndex].delivery!.location!.name}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                          ),
                                          child: Text(
                                            "${widget.deliveriesList[listIndex].delivery!.location!.phone}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: pale,
                                      height: 50,
                                      width: 1,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await launchUrl(Uri.parse(
                                                "tel://${widget.deliveriesList[listIndex].delivery!.location!.phone}"));
                                          },
                                          child: const Icon(
                                            PhosphorIcons.phone_call,
                                            size: 20,
                                            color: link,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: InkWell(
                                            onTap: () async {
                                              await launchUrl(Uri.parse(
                                                  "$mapUrl&query=${widget.deliveriesList[listIndex].delivery!.location!.latitude},${widget.deliveriesList[listIndex].delivery!.location!.longitude}"));
                                            },
                                            child: const Icon(
                                              PhosphorIcons.map_pin,
                                              size: 20,
                                              color: link,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
