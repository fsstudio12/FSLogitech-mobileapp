import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:nova/bloc/nova_bloc.dart';
import 'package:nova/models/nova_model.dart';
import 'package:nova/screens/image_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import 'start_pickup_screen.dart';

class PickupDetailScreen extends StatefulWidget {
  final String pickupId;
  final num applicationId;
  const PickupDetailScreen(
      {Key? key, required this.pickupId, required this.applicationId})
      : super(key: key);

  @override
  State<PickupDetailScreen> createState() => _PickupDetailScreenState();
}

class _PickupDetailScreenState extends State<PickupDetailScreen> {
  NovaBloc ovaBloc = NovaBloc();
  TextEditingController markFailedController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ovaBloc.add(GetPickupDetailEvent(id: widget.pickupId));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PickupDetailResponseModel>(
        stream: ovaBloc.outPickupDetailResponse,
        builder: (context, outPickupDetailResponseSnapshot) {
          if (outPickupDetailResponseSnapshot.data != null) {
            return Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.black),
                  backgroundColor: Colors.transparent,
                  title: Text("#${widget.applicationId}"),
                  elevation: 0,
                  actions: [
                    outPickupDetailResponseSnapshot
                                .data!.application![0].status ==
                            "ongoing"
                        ? PopupMenuButton<Popme>(
                            onSelected: (Popme result) async {
                              if (result == Popme.call) {
                                await launchUrl(Uri.parse(
                                    "tel://${outPickupDetailResponseSnapshot.data!.application![0].farmer!.phoneNumber!}"));
                              } else if (result == Popme.navigate) {
                                if (await canLaunchUrl(Uri.parse(
                                    "$mapUrl&query=${outPickupDetailResponseSnapshot.data!.application![0].adminPickUpLocationAlt}"))) {
                                  await launchUrl(Uri.parse(
                                      "$mapUrl&query=${outPickupDetailResponseSnapshot.data!.application![0].adminPickUpLocationAlt}"));
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
                                                controller:
                                                    markFailedController,
                                                decoration: const InputDecoration(
                                                    border:
                                                        OutlineInputBorder()),
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
                                              style:
                                                  TextStyle(color: secondary),
                                            ),
                                          ),
                                          MaterialButton(
                                            color: secondary,
                                            onPressed: () {
                                              ovaBloc.add(MarkFailedEvent(
                                                  context: context,
                                                  applicationId:
                                                      widget.pickupId,
                                                  reason: markFailedController
                                                      .text));
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Proceed",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 15),
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
                                      AppConfig().timeFormat.format(
                                          outPickupDetailResponseSnapshot
                                              .data!
                                              .application![0]
                                              .adminPickUpDate!),
                                      style: const TextStyle(
                                          color: darkGray,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: outPickupDetailResponseSnapshot
                                                    .data!
                                                    .application![0]
                                                    .status ==
                                                "pending"
                                            ? pending
                                            : outPickupDetailResponseSnapshot
                                                        .data!
                                                        .application![0]
                                                        .status ==
                                                    "ongoing"
                                                ? processing
                                                : outPickupDetailResponseSnapshot
                                                            .data!
                                                            .application![0]
                                                            .status ==
                                                        "completed"
                                                    ? completed
                                                    : failed),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  child: Text(
                                    outPickupDetailResponseSnapshot
                                                .data!.application![0].status ==
                                            "pending"
                                        ? "Pending"
                                        : outPickupDetailResponseSnapshot.data!
                                                    .application![0].status ==
                                                "ongoing"
                                            ? "Processing"
                                            : outPickupDetailResponseSnapshot
                                                        .data!
                                                        .application![0]
                                                        .status ==
                                                    "completed"
                                                ? "Completed"
                                                : "Failed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: outPickupDetailResponseSnapshot
                                                    .data!
                                                    .application![0]
                                                    .status ==
                                                "pending"
                                            ? pending
                                            : outPickupDetailResponseSnapshot
                                                        .data!
                                                        .application![0]
                                                        .status ==
                                                    "ongoing"
                                                ? processing
                                                : outPickupDetailResponseSnapshot
                                                            .data!
                                                            .application![0]
                                                            .status ==
                                                        "completed"
                                                    ? completed
                                                    : failed),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          outPickupDetailResponseSnapshot
                                      .data!.application![0].status ==
                                  "failed"
                              ? outPickupDetailResponseSnapshot
                                          .data!.application![0].reason !=
                                      null
                                  ? Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 15),
                                          child: Text(
                                            "Reason",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Text(
                                          outPickupDetailResponseSnapshot
                                              .data!.application![0].reason,
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
                              "Farmer Details",
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
                                    outPickupDetailResponseSnapshot
                                        .data!.application![0].farmer!.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Text(
                                      outPickupDetailResponseSnapshot.data!
                                          .application![0].farmer!.phoneNumber!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    outPickupDetailResponseSnapshot
                                        .data!
                                        .application![0]
                                        .adminPickUpLocationString!,
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
                              "Products",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Column(
                            children: List.generate(
                                outPickupDetailResponseSnapshot
                                    .data!
                                    .application![0]
                                    .products!
                                    .length, (productsIndex) {
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
                                          outPickupDetailResponseSnapshot
                                              .data!
                                              .application![0]
                                              .products![productsIndex]
                                              .images![0]
                                              .imageUrl!,
                                          height: 50,
                                          width: 50),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              outPickupDetailResponseSnapshot
                                                  .data!
                                                  .application![0]
                                                  .products![productsIndex]
                                                  .productName!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Text(
                                                "Qty: ${outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantity!}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Rs. ${outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminEstimatedPrice!}/${outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantityUnit!}",
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
                          outPickupDetailResponseSnapshot
                                      .data!.application![0].status ==
                                  "completed"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 15),
                                      child: Text(
                                        "Proof of pickup",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Wrap(
                                        direction: Axis.horizontal,
                                        children: List.generate(
                                            outPickupDetailResponseSnapshot
                                                .data!
                                                .application![0]
                                                .proofOfPickup!
                                                .length, (proofOfPickupIndex) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => ImageViewScreen(
                                                    image: outPickupDetailResponseSnapshot
                                                        .data!
                                                        .application![0]
                                                        .proofOfPickup![
                                                            proofOfPickupIndex]
                                                        .imageUrl!),
                                              ));
                                            },
                                            child: Image.network(
                                              outPickupDetailResponseSnapshot
                                                  .data!
                                                  .application![0]
                                                  .proofOfPickup![
                                                      proofOfPickupIndex]
                                                  .imageUrl!,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        })),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 15),
                                      child: Text(
                                        "Signature",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => ImageViewScreen(
                                              image:
                                                  outPickupDetailResponseSnapshot
                                                      .data!
                                                      .application![0]
                                                      .signature!
                                                      .imageUrl!),
                                        ));
                                      },
                                      child: Image.network(
                                        outPickupDetailResponseSnapshot
                                            .data!
                                            .application![0]
                                            .signature!
                                            .imageUrl!,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: outPickupDetailResponseSnapshot
                                      .data!.application![0].status ==
                                  "pending"
                              ? MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  color: secondary,
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text(
                                      "Start pickup process",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                StartPickupScreen(
                                                  pickupId:
                                                      outPickupDetailResponseSnapshot
                                                          .data!
                                                          .application![0]
                                                          .id!,
                                                ))));
                                  })
                              : outPickupDetailResponseSnapshot
                                          .data!.application![0].status ==
                                      "failed"
                                  ? MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      color: secondary,
                                      child: StreamBuilder<bool>(
                                          initialData: false,
                                          stream: ovaBloc.outIsProcessing,
                                          builder: (context,
                                              outIsProcessingSnapshot) {
                                            return outIsProcessingSnapshot.data!
                                                ? LinearProgressIndicator(
                                                    backgroundColor:
                                                        Colors.white,
                                                    color: primary,
                                                  )
                                                : const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15, bottom: 15),
                                                    child: Text(
                                                      "Retry Pickup",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  );
                                          }),
                                      onPressed: () {
                                        ovaBloc.inIsProcessing.add(true);
                                        ovaBloc.add(RetryPickupEvent(
                                            applicationId: widget.pickupId,
                                            context: context));
                                      })
                                  : Container())
                    ],
                  ),
                ));
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text("#${widget.applicationId}"),
                elevation: 0,
              ),
              body: AppConfig().shimmers(context),
            );
          }
        });
  }
}
