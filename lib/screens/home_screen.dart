import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nova/app_config.dart';
import 'package:nova/bloc/nova_bloc.dart';
import 'package:nova/models/nova_model.dart';
import 'package:nova/screens/login_screen.dart';
import 'package:nova/screens/rider_profile_screen.dart';
import 'package:nova/services/hive_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'delivery_detail_screen.dart';
import 'deliveries_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NovaBloc novaBloc = NovaBloc();
  Map<DateTime, List<MonthOrder>> addedDeliveriesCalendar = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    novaBloc.add(GetCalendarEvent(refreshController: refreshController));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Image.asset(
            "assets/images/finalized_nova_logo.png",
            height: 25,
            width: 25,
            fit: BoxFit.fill,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RiderProfileScreen()));
              },
              icon: const Icon(PhosphorIcons.user),
            ),
            StreamBuilder<CalendarResponseModel>(
                stream: novaBloc.outCalendarResponse,
                builder: (context, outCalendarResponseSnapshot) {
                  if (outCalendarResponseSnapshot.data != null) {
                    return IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  child: StatefulBuilder(
                                      builder: (context, setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TableCalendar(
                                          calendarBuilders: CalendarBuilders(
                                            markerBuilder: (context, day,
                                                List<dynamic> events) {
                                              if (events.isNotEmpty) {
                                                return Positioned(
                                                  right: 1,
                                                  bottom: 1,
                                                  child: Row(
                                                    children: [
                                                      events[0].successfulOrdersCount >
                                                              0
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 3),
                                                              child: Container(
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .green),
                                                                width: 16.0,
                                                                height: 16.0,
                                                                child: Center(
                                                                  child: Text(
                                                                    '${events[0].successfulOrdersCount}',
                                                                    style: const TextStyle()
                                                                        .copyWith(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      events[0].failedOrdersCount >
                                                              0
                                                          ? Container(
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .red),
                                                              width: 16.0,
                                                              height: 16.0,
                                                              child: Center(
                                                                child: Text(
                                                                  '${events[0].failedOrdersCount}',
                                                                  style: const TextStyle()
                                                                      .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                          focusedDay: selectedDay,
                                          firstDay: DateTime(1990),
                                          lastDay: DateTime(2050),
                                          calendarFormat: format,

                                          startingDayOfWeek:
                                              StartingDayOfWeek.sunday,
                                          daysOfWeekVisible: true,
                                          onFormatChanged: (_format) {
                                            setState(
                                              () => format = _format,
                                            );
                                          },

                                          //Day Changed
                                          onDaySelected: (DateTime selectDay,
                                              DateTime focusDay) {
                                            if (addedDeliveriesCalendar[
                                                    selectDay] !=
                                                null) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          DeliveriesListScreen(
                                                            type: AppConfig()
                                                                .standardDate1
                                                                .format(
                                                                    selectDay),
                                                            deliveriesList:
                                                                addedDeliveriesCalendar[
                                                                        selectDay]![0]
                                                                    .orders!,
                                                          ))));
                                            }
                                          },
                                          selectedDayPredicate:
                                              (DateTime date) {
                                            return isSameDay(selectedDay, date);
                                          },

                                          eventLoader: (date) {
                                            for (int i = 0;
                                                i <
                                                    outCalendarResponseSnapshot
                                                        .data!
                                                        .monthOrders!
                                                        .length;
                                                i++) {
                                              addedDeliveriesCalendar[
                                                  DateTime.parse(
                                                      "${AppConfig().standardDate.format(outCalendarResponseSnapshot.data!.monthOrders![i].startDate!)} 00:00:00.000Z")] = [
                                                outCalendarResponseSnapshot
                                                    .data!.monthOrders![i]
                                              ];
                                            }
                                            print(
                                                addedDeliveriesCalendar[date]);

                                            return addedDeliveriesCalendar[
                                                    date] ??
                                                [];
                                          },

                                          //To style the Calendar
                                          calendarStyle: CalendarStyle(
                                            isTodayHighlighted: true,
                                            selectedDecoration: BoxDecoration(
                                              color: pale,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            selectedTextStyle: const TextStyle(
                                                color: Colors.black),
                                            todayDecoration: BoxDecoration(
                                              color: pale,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            defaultDecoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            weekendDecoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          headerStyle: HeaderStyle(
                                            formatButtonVisible: true,
                                            titleCentered: true,
                                            formatButtonShowsNext: false,
                                            formatButtonDecoration:
                                                BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            formatButtonTextStyle:
                                                const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                );
                              });
                        },
                        icon: const Icon(PhosphorIcons.calendar_blank));
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
        body: SmartRefresher(
          physics: const BouncingScrollPhysics(),
          onRefresh: () async {
            novaBloc
                .add(GetCalendarEvent(refreshController: refreshController));
          },
          controller: refreshController,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 9),
            child: StreamBuilder<CalendarResponseModel>(
                stream: novaBloc.outCalendarResponse,
                builder: (context, outTodaysStatusResponseSnapshot) {
                  if (outTodaysStatusResponseSnapshot.data != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        outTodaysStatusResponseSnapshot
                                .data!.todayOrders!.ongoing!.isEmpty
                            ? Text(
                                "Hello ${HiveService().getDriverDetail().name} ",
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: primary),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ongoing Deliveries (${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing!.length})",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 19),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children: List.generate(
                                                outTodaysStatusResponseSnapshot
                                                    .data!
                                                    .todayOrders!
                                                    .ongoing!
                                                    .length, (ongoingIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              decoration: BoxDecoration(
                                                  color: background,
                                                  border: Border.all(
                                                    color: gray,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            right: 12,
                                                            top: 15,
                                                            bottom: 12),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "#${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing![ongoingIndex].orderId}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      darkGray),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                          color:
                                                                              processing),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3)),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 4,
                                                                        bottom:
                                                                            4,
                                                                        left:
                                                                            19.24,
                                                                        right:
                                                                            19.76),
                                                                child: Text(
                                                                  "Ongoing",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          10,
                                                                      color:
                                                                          processing),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                PhosphorIcons
                                                                    .clock,
                                                                color: darkGray,
                                                                size: 15,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  AppConfig()
                                                                      .timeFormat
                                                                      .format(outTodaysStatusResponseSnapshot
                                                                          .data!
                                                                          .todayOrders!
                                                                          .ongoing![
                                                                              ongoingIndex]
                                                                          .createdAt!),
                                                                  style:
                                                                      const TextStyle(
                                                                    color:
                                                                        darkGray,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                PhosphorIcons
                                                                    .map_pin,
                                                                color: darkGray,
                                                                size: 15,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  "${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing![ongoingIndex].delivery!.location!.address}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(context).push(MaterialPageRoute(
                                                                    builder: ((context) => DeliveryDetailScreen(
                                                                        order: outTodaysStatusResponseSnapshot
                                                                            .data!
                                                                            .todayOrders!
                                                                            .ongoing![ongoingIndex]))));
                                                              },
                                                              child: Row(
                                                                children: const [
                                                                  Text(
                                                                    "View details",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            link,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .caret_right,
                                                                    size: 15,
                                                                    color: link,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(height: 0),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 12,
                                                      right: 12,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing![ongoingIndex].delivery!.location!.name}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 5,
                                                              ),
                                                              child: Text(
                                                                "${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing![ongoingIndex].delivery!.location!.phone}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
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
                                                                await launchUrl(
                                                                    Uri.parse(
                                                                        "tel://${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing![ongoingIndex].delivery!.location!.phone}"));
                                                              },
                                                              child: Row(
                                                                children: const [
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .phone_call,
                                                                    size: 20,
                                                                    color: link,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 25),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await launchUrl(
                                                                      Uri.parse(
                                                                          "$mapUrl&query=${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing![ongoingIndex].delivery!.location!.latitude},${outTodaysStatusResponseSnapshot.data!.todayOrders!.ongoing![ongoingIndex].delivery!.location!.longitude}"));
                                                                },
                                                                child: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      PhosphorIcons
                                                                          .map_pin,
                                                                      size: 20,
                                                                      color:
                                                                          link,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        })),
                                      )

                                      // CarouselSlider(
                                      //     options: CarouselOptions(
                                      //         height: 250.0,
                                      //         autoPlay: true,
                                      //         enlargeCenterPage: true,
                                      //         autoPlayInterval:
                                      //             const Duration(seconds: 10)),
                                      //     items: List.generate(
                                      //         outTodaysStatusResponseSnapshot.data!
                                      //             .ongoing!.length, (ongoingIndex) {
                                      //       return Builder(
                                      //         builder: (BuildContext context) {
                                      //           return
                                      //            Container(
                                      //             height: 250,
                                      //             width: MediaQuery.of(context)
                                      //                 .size
                                      //                 .width,
                                      //             decoration: BoxDecoration(
                                      //                 border: Border.all(
                                      //                   color: pale,
                                      //                 ),
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(5)),
                                      //             child: Column(
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment.start,
                                      //               children: [
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets.only(
                                      //                           left: 10,
                                      //                           right: 10,
                                      //                           top: 10),
                                      //                   child: Column(
                                      //                     crossAxisAlignment:
                                      //                         CrossAxisAlignment
                                      //                             .start,
                                      //                     children: [
                                      //                       Row(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .spaceBetween,
                                      //                         children: [
                                      //                           Text(
                                      //                             "#${outTodaysStatusResponseSnapshot.data!.ongoing![ongoingIndex].applicationId}",
                                      //                             style: const TextStyle(
                                      //                                 fontWeight:
                                      //                                     FontWeight
                                      //                                         .w700,
                                      //                                 color: link),
                                      //                           ),
                                      //                           Container(
                                      //                             decoration: BoxDecoration(
                                      //                                 border: Border
                                      //                                     .all(
                                      //                                         color:
                                      //                                             processing),
                                      //                                 borderRadius:
                                      //                                     BorderRadius
                                      //                                         .circular(
                                      //                                             5)),
                                      //                             child:
                                      //                                 const Padding(
                                      //                               padding: EdgeInsets
                                      //                                   .only(
                                      //                                       top: 5,
                                      //                                       bottom:
                                      //                                           5,
                                      //                                       left:
                                      //                                           10,
                                      //                                       right:
                                      //                                           10),
                                      //                               child: Text(
                                      //                                 "Processing",
                                      //                                 style: TextStyle(
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .w700,
                                      //                                     color:
                                      //                                         processing),
                                      //                               ),
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                       Padding(
                                      //                         padding:
                                      //                             const EdgeInsets
                                      //                                     .only(
                                      //                                 top: 5,
                                      //                                 bottom: 5),
                                      //                         child: Row(
                                      //                           children: [
                                      //                             const Icon(
                                      //                               PhosphorIcons
                                      //                                   .clock,
                                      //                               color: darkGray,
                                      //                             ),
                                      //                             Padding(
                                      //                               padding:
                                      //                                   const EdgeInsets
                                      //                                           .only(
                                      //                                       left:
                                      //                                           10),
                                      //                               child: Text(
                                      //                                 AppConfig()
                                      //                                     .timeFormat
                                      //                                     .format(outTodaysStatusResponseSnapshot
                                      //                                         .data!
                                      //                                         .ongoing![
                                      //                                             ongoingIndex]
                                      //                                         .adminPickUpDate!),
                                      //                                 style:
                                      //                                     const TextStyle(
                                      //                                   color:
                                      //                                       darkGray,
                                      //                                   fontWeight:
                                      //                                       FontWeight
                                      //                                           .w700,
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                       Row(
                                      //                         children: [
                                      //                           outTodaysStatusResponseSnapshot
                                      //                                       .data!
                                      //                                       .ongoing![
                                      //                                           ongoingIndex]
                                      //                                       .farmer!
                                      //                                       .image !=
                                      //                                   null
                                      //                               ? const Padding(
                                      //                                   padding: EdgeInsets
                                      //                                       .only(
                                      //                                           left:
                                      //                                               10),
                                      //                                   child: Icon(
                                      //                                     PhosphorIcons
                                      //                                         .clock,
                                      //                                     color:
                                      //                                         darkGray,
                                      //                                   ),
                                      //                                 )
                                      //                               : Container(),
                                      //                           Column(
                                      //                             crossAxisAlignment:
                                      //                                 CrossAxisAlignment
                                      //                                     .start,
                                      //                             children: [
                                      //                               Text(
                                      //                                 "${outTodaysStatusResponseSnapshot.data!.ongoing![ongoingIndex].farmer!.name}",
                                      //                                 style: const TextStyle(
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .w700),
                                      //                               ),
                                      //                               Padding(
                                      //                                 padding:
                                      //                                     const EdgeInsets
                                      //                                         .only(
                                      //                                   top: 5,
                                      //                                 ),
                                      //                                 child: Text(
                                      //                                   "${outTodaysStatusResponseSnapshot.data!.ongoing![ongoingIndex].farmer!.phoneNumber}",
                                      //                                   style: const TextStyle(
                                      //                                       fontWeight:
                                      //                                           FontWeight.w400),
                                      //                                 ),
                                      //                               ),
                                      //                             ],
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                       Padding(
                                      //                         padding:
                                      //                             const EdgeInsets
                                      //                                     .only(
                                      //                                 top: 5,
                                      //                                 bottom: 5),
                                      //                         child: Text(
                                      //                           "${outTodaysStatusResponseSnapshot.data!.ongoing![ongoingIndex].adminPickUpLocationString}",
                                      //                           style: const TextStyle(
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .w400),
                                      //                         ),
                                      //                       ),
                                      //                       Row(
                                      //                         children: const [
                                      //                           Text(
                                      //                             "View details",
                                      //                             style: TextStyle(
                                      //                                 fontSize: 12,
                                      //                                 color: link,
                                      //                                 fontWeight:
                                      //                                     FontWeight
                                      //                                         .w700),
                                      //                           ),
                                      //                           Icon(
                                      //                             PhosphorIcons
                                      //                                 .caret_right,
                                      //                             size: 15,
                                      //                             color: link,
                                      //                           )
                                      //                         ],
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           );

                                      //         },
                                      //       );
                                      //     })),
                                      )
                                ],
                              ),
                        const Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 15),
                          child: Text(
                            "Today's Status",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _deliveriesDesign(
                            "Pending",
                            outTodaysStatusResponseSnapshot
                                .data!.todayOrders!.pending,
                            PhosphorIcons.truck),
                        _deliveriesDesign(
                            "Completed",
                            outTodaysStatusResponseSnapshot
                                .data!.todayOrders!.completed,
                            PhosphorIcons.check_circle),
                        _deliveriesDesign(
                            "Failed",
                            outTodaysStatusResponseSnapshot
                                .data!.todayOrders!.failed,
                            PhosphorIcons.warning_circle),
                      ],
                    );
                  } else {
                    return AppConfig().shimmers(context);
                  }
                }),
          ),
        ));
  }

  _deliveriesDesign(type, list, icon) {
    return InkWell(
      onTap: () {
        if (list.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DeliveriesListScreen(
                    deliveriesList: list,
                    type: type,
                  )));
        }
      },
      child: Padding(
        padding: type == "Completed"
            ? const EdgeInsets.only(top: 15, bottom: 15)
            : const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: pale)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(
                    icon,
                    color: primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$type Deliveries",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${list.length}",
                          style: const TextStyle(
                            color: darkGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                const Icon(
                  PhosphorIcons.caret_right,
                  color: darkGray,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
