import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:nova/screens/pickup_detail_screen.dart';
import 'package:nova/screens/start_pickup_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import '../models/nova_model.dart';

class PickUpsListScreen extends StatefulWidget {
  final List<Pickup> pickUpsList;
  final String type;

  const PickUpsListScreen(
      {Key? key, required this.pickUpsList, required this.type})
      : super(key: key);

  @override
  State<PickUpsListScreen> createState() => _PickUpsListScreenState();
}

class _PickUpsListScreenState extends State<PickUpsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("${widget.type} Pickups"),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(widget.pickUpsList.length, (listIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: pale,
                  ),
                  borderRadius: BorderRadius.circular(5)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#${widget.pickUpsList[listIndex].applicationId}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, color: link),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: widget.pickUpsList[listIndex]
                                                  .status ==
                                              "pending"
                                          ? pending
                                          : widget.pickUpsList[listIndex]
                                                      .status ==
                                                  "completed"
                                              ? completed
                                              : widget.pickUpsList[listIndex]
                                                          .status ==
                                                      "ongoing"
                                                  ? processing
                                                  : failed),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                child: Text(
                                  widget.pickUpsList[listIndex].status ==
                                          "ongoing"
                                      ? "Processing"
                                      : widget.pickUpsList[listIndex].status ==
                                              "completed"
                                          ? "Completed"
                                          : widget.pickUpsList[listIndex]
                                                      .status ==
                                                  "pending"
                                              ? "Pending"
                                              : "Failed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: widget.pickUpsList[listIndex]
                                                  .status ==
                                              "pending"
                                          ? pending
                                          : widget.pickUpsList[listIndex]
                                                      .status ==
                                                  "ongoing"
                                              ? processing
                                              : widget.pickUpsList[listIndex]
                                                          .status ==
                                                      "completed"
                                                  ? completed
                                                  : failed),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: [
                              const Icon(
                                PhosphorIcons.clock,
                                color: darkGray,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  AppConfig().timeFormat.format(widget
                                      .pickUpsList[listIndex].adminPickUpDate!),
                                  style: const TextStyle(
                                    color: darkGray,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            widget.pickUpsList[listIndex].farmer!.image != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(widget
                                          .pickUpsList[listIndex]
                                          .farmer!
                                          .image!),
                                    ))
                                : Container(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.pickUpsList[listIndex].farmer!.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Text(
                                    "${widget.pickUpsList[listIndex].farmer!.phoneNumber}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "${widget.pickUpsList[listIndex].adminPickUpLocationString}",
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => PickupDetailScreen(
                                      applicationId: widget
                                          .pickUpsList[listIndex]
                                          .applicationId!,
                                      pickupId:
                                          widget.pickUpsList[listIndex].id!,
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
                                      fontWeight: FontWeight.w700),
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
                        widget.pickUpsList[listIndex].status == "pending"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 10,
                                ),
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              StartPickupScreen(
                                                pickupId: widget
                                                    .pickUpsList[listIndex].id!,
                                              )))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: pending),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 10,
                                          right: 10),
                                      child: Text(
                                        "Start pickup process",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: pending),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          await launch(
                              "tel://${widget.pickUpsList[listIndex].farmer!.phoneNumber!}");
                        },
                        child: Row(
                          children: const [
                            Icon(
                              PhosphorIcons.phone_call,
                              size: 20,
                              color: link,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Call",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: link),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: pale,
                        height: 50,
                        width: 1,
                      ),
                      InkWell(
                        onTap: () async {
                          if (await canLaunch(mapUrl +
                              "&query=${widget.pickUpsList[listIndex].adminPickUpLocationAlt}")) {
                            await launch(mapUrl +
                                "&query=${widget.pickUpsList[listIndex].adminPickUpLocationAlt}");
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(
                              PhosphorIcons.map_pin,
                              size: 20,
                              color: link,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Navigate",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: link),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        })),
      ),
    );
  }
}
