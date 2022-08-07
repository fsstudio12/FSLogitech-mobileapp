import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nova/bloc/nova_bloc.dart';
import 'package:nova/models/nova_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final Order order;
  const DeliveryDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  NovaBloc novaBloc = NovaBloc();
  TextEditingController markFailedController = TextEditingController();
  String? selectedMethod;
  Uint8List? proofImage;

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
            widget.order.status == "Picked Up"
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
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, right: 15, left: 15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text("Mark as failed?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Divider(),
                                        ),
                                        const Text("Reason",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: TextField(
                                            controller: markFailedController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      // width: 5.0,
                                                      color: primary),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: MaterialButton(
                                                  color: primary,
                                                  onPressed: () {
                                                    novaBloc.inIsLoading
                                                        .add(true);
                                                    novaBloc.add(MarkFailedEvent(
                                                        context: context,
                                                        orderId: widget
                                                            .order.orderId,
                                                        reason:
                                                            markFailedController
                                                                .text));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            });

                        // showDialog(
                        //     context: context,
                        //     builder: (dialogContext) {
                        //       return AlertDialog(
                        //         title: const Text("Mark as failed?"),
                        //         content: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               const Text("Reason"),
                        //               Padding(
                        //                 padding: const EdgeInsets.only(top: 10),
                        //                 child: TextField(
                        //                   controller: markFailedController,
                        //                   decoration: const InputDecoration(
                        //                       border: OutlineInputBorder()),
                        //                 ),
                        //               ),
                        //               OutlinedButton(
                        //                 style: OutlinedButton.styleFrom(
                        //                   side: const BorderSide(
                        //                       // width: 5.0,
                        //                       color: primary),
                        //                 ),
                        //                 onPressed: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //                 child: const Text(
                        //                   "Cancel",
                        //                   style: TextStyle(color: primary),
                        //                 ),
                        //               ),
                        //               MaterialButton(
                        //                 color: primary,
                        //                 onPressed: () {
                        //                   novaBloc.inIsLoading.add(true);
                        //                   novaBloc.add(MarkFailedEvent(
                        //                       context: context,
                        //                       orderId: widget.order.orderId,
                        //                       reason:
                        //                           markFailedController.text));
                        //                   Navigator.of(context).pop();
                        //                 },
                        //                 child: const Text(
                        //                   "Proceed",
                        //                   style: TextStyle(color: Colors.white),
                        //                 ),
                        //               ),
                        //             ]),
                        //       );
                        //     });

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
              Padding(
                padding: EdgeInsets.only(
                    bottom: (widget.order.status == "Picked Up" ||
                            widget.order.status == "Pending")
                        ? 60
                        : 0),
                child: SingleChildScrollView(
                  child: Column(
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
                                    color: darkGray,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.order.status == "Pending"
                                        ? pending
                                        : widget.order.status == "Picked Up"
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
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: widget.order.status == "Pending"
                                        ? pending
                                        : widget.order.status == "Picked Up"
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
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 15),
                                      child: Text(
                                        "Reason",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Text(
                                      widget.order.delivery!.failReason!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                )
                              : Container()
                          : Container(),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 15),
                        child: Text(
                          "Customer Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Column(
                        children: List.generate(widget.order.foods!.length,
                            (foodsIndex) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.order.foods![foodsIndex].name!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
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
                                            fontWeight: FontWeight.w400,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 15),
                            child: Text(
                              "Payment Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                          ExpansionTile(
                            childrenPadding: const EdgeInsets.only(bottom: 10),
                            tilePadding: const EdgeInsets.all(0),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text("Rs. ${widget.order.payment!.total!}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ))
                              ],
                            ),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Sub Total",
                                      style: TextStyle(
                                        color: darkGray,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  Text("Rs. ${widget.order.payment!.subTotal!}",
                                      style: const TextStyle(
                                        color: darkGray,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Discount",
                                      style: TextStyle(
                                        color: darkGray,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  Text("Rs. ${widget.order.payment!.discount!}",
                                      style: const TextStyle(
                                        color: darkGray,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ))
                                ],
                              ),
                              widget.order.payment!.taxes != null
                                  ? Column(
                                      children: List.generate(
                                          widget.order.payment!.taxes!.length,
                                          (taxIndex) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${widget.order.payment!.taxes![taxIndex].name}",
                                                style: const TextStyle(
                                                  color: darkGray,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            Text(
                                                "Rs. ${widget.order.payment!.taxes![taxIndex].amount}",
                                                style: const TextStyle(
                                                  color: darkGray,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ))
                                          ],
                                        );
                                      }),
                                    )
                                  : Container()
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Status",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(widget.order.payment!.isPaid!
                                    ? "Paid"
                                    : "Unpaid")
                              ],
                            ),
                          ),
                          widget.order.status == "Picked Up"
                              ? StreamBuilder<String>(
                                  stream: novaBloc
                                      .outSelectedPaymentMethodFromDropdown,
                                  builder: (context,
                                      outSelectedPaymentMethodFromDropdownSnapshot) {
                                    selectedMethod =
                                        outSelectedPaymentMethodFromDropdownSnapshot
                                            .data;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Paid via"),
                                              widget.order.payment!.isPaid!
                                                  ? Text(widget
                                                      .order.payment!.method!)
                                                  : Container(
                                                      height: 25,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: darkGray)),
                                                      child: DropdownButton<
                                                          String>(
                                                        value:
                                                            outSelectedPaymentMethodFromDropdownSnapshot
                                                                .data,
                                                        hint: const Text(
                                                            "Select One"),
                                                        iconSize: 0,
                                                        elevation: 0,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                        underline: Container(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          novaBloc
                                                              .inSelectedPaymentMethodFromDropdown
                                                              .add(newValue!);
                                                        },
                                                        items: <String>[
                                                          'Cash',
                                                          'Esewa',
                                                          'FonePay',
                                                          'Khalti'
                                                        ].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          outSelectedPaymentMethodFromDropdownSnapshot
                                                          .data !=
                                                      null &&
                                                  outSelectedPaymentMethodFromDropdownSnapshot
                                                          .data !=
                                                      "Cash"
                                              ? StreamBuilder<Uint8List>(
                                                  stream:
                                                      novaBloc.outProofImage,
                                                  builder: (context,
                                                      outProofImageSnapshot) {
                                                    proofImage =
                                                        outProofImageSnapshot
                                                            .data;
                                                    return outProofImageSnapshot
                                                                .data !=
                                                            null
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: Image.memory(
                                                                outProofImageSnapshot
                                                                    .data!,
                                                                height: 100,
                                                                width: 100,
                                                                fit: BoxFit
                                                                    .fill),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: InkWell(
                                                              onTap: () {
                                                                getProofImage();
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            darkGray),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                      children: const [
                                                                        Text(
                                                                            "Scan receipt"),
                                                                        Icon(PhosphorIcons
                                                                            .caret_right)
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                  })
                                              : Container()
                                        ],
                                      ),
                                    );
                                  })
                              : Container(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              StreamBuilder<bool>(
                  initialData: false,
                  stream: novaBloc.outIsLoading,
                  builder: (context, outIsLoadingSnapshot) {
                    return Align(
                        alignment: Alignment.bottomCenter,
                        child: widget.order.status == "Pending"
                            ? MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minWidth: MediaQuery.of(context).size.width,
                                color: secondary,
                                onPressed: outIsLoadingSnapshot.data!
                                    ? null
                                    : () {
                                        novaBloc.inIsLoading.add(true);
                                        novaBloc.add(StartDeliveryEvent(
                                            context: context,
                                            orderIds: [widget.order.orderId]));
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  child: outIsLoadingSnapshot.data!
                                      ? const LinearProgressIndicator()
                                      : const Text(
                                          "Start Delivery Process",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                ))
                            : widget.order.status == "Picked Up"
                                ? MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    color: primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: outIsLoadingSnapshot.data!
                                        ? null
                                        : () {
                                            if (widget.order.payment!.isPaid!) {
                                              novaBloc.inIsLoading.add(true);
                                              novaBloc.add(
                                                  CompleteDeliveryEvent(
                                                      context: context,
                                                      orderId: widget
                                                          .order.orderId));
                                            } else {
                                              if (selectedMethod != null &&
                                                  proofImage != null) {
                                                novaBloc.inIsLoading.add(true);
                                                novaBloc.add(
                                                    CompleteDeliveryEvent(
                                                        context: context,
                                                        image: proofImage,
                                                        method: selectedMethod,
                                                        orderId: widget
                                                            .order.orderId));
                                              }
                                            }
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15),
                                      child: outIsLoadingSnapshot.data!
                                          ? const LinearProgressIndicator()
                                          : const Text(
                                              "Complete Delivery Process",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                    ))
                                : Container());
                  })
            ],
          ),
        ));
  }

  Future getProofImage({ImageSource? selectedSource}) async {
    try {
      var pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        Uint8List uint8list =
            Uint8List.fromList(File(pickedFile.path).readAsBytesSync());

        novaBloc.inProofImage.add(uint8list);
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
