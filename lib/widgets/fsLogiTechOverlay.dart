import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:nova/app_config.dart';
import 'package:nova/models/nova_model.dart';

class FsLogitechOverlay {
  OverlayEntry notificationOverlay(Offset offset, Size iconSize, AsyncSnapshot<CalendarResponseModel> inAppNotificationsSnapshot ,Function() viewAllCallBack, Function(String id) deliveryClickedCallBack) {
    
    return OverlayEntry(
      builder: (context) {
      double overlayHeight = MediaQuery.of(context).size.width * 7 / 8;
      double overlayWidth = MediaQuery.of(context).size.width * 5 / 8;

      return Positioned(
        top: offset.dy + iconSize.height ,
        right: 12,
        height: overlayHeight,
        width: overlayWidth,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                color: Color.fromRGBO(59, 102, 255, 0.1),
                blurRadius: 8,
                offset: Offset(4, 4)
              ),
                BoxShadow(
                color: Color.fromRGBO(59, 102, 255, 0.1),
                blurRadius: 8,
                offset: Offset(-4, 4)
              ),
              ]
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          viewAllCallBack();
                        },
                        child: const Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.5,
                            color: link,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                inAppNotificationsSnapshot.hasData ? Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: inAppNotificationsSnapshot.data!.notifications?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime notificationTime = inAppNotificationsSnapshot.data!.notifications![index].createdAt;
                        return InkWell(
                          onTap: () {
                            deliveryClickedCallBack(inAppNotificationsSnapshot.data!.notifications![index].entityId);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: gray,
                              )
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      PhosphorIcons.truck,
                                      size: 18,
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(bottom: 4.0),
                                          child: Text(
                                            inAppNotificationsSnapshot.data!.notifications![index].title,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: black,
                                            ),
                                          ),
                                        ),
                                      Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            inAppNotificationsSnapshot.data!.notifications![index].body,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: black,
                                            ),
                                          ),
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${DateFormat('MMM').format(notificationTime)} ${notificationTime.day}, ${notificationTime.year} ${notificationTime.hour}:${notificationTime.minute}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: darkGray,
                                            ),
                                          ),
                                          Text(
                                            inAppNotificationsSnapshot.data!.notifications![index].isRead ? "Read" : "",
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: darkGray,
                                            ),
                                          ),
                                        ],
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
                ): Container()
              ],
            ),
          ),
        ),
      );
    });
  }
}
