import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/noti.dart';
import 'package:iov/model/noti_group.dart';
import 'package:iov/page/home_noti_map.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/timeago.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/back_ios.dart';


import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../model/last_key.dart';
import 'home_car_sort.dart';

// Noti? notiSelect;

class HomeNotiEventPage extends StatefulWidget {
  HomeNotiEventPage({Key? key, this.listData, this.name}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  List<Noti>? listData = [];
  String? name;

  // String? license;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeNotiEventPage> {
  @override
  void initState() {
    if (widget.listData != null) {
      listDriver.addAll(widget.listData!);
      groupSection();
    } else {
      getData(context, []);
    }
    super.initState();
  }

  List<Noti> listData = [];
  bool isLoading = false;

  getData(BuildContext context, List<LastEvaluatedKey> listLast) {
    isLoading = true;
    refresh();
    String param;
    if (listLast.isNotEmpty) {
      param = jsonEncode(<dynamic, dynamic>{
        "user_id": Api.profile?.userId,
        "per_page": 500,
        "event_list": [1001, 10000, 10001],
        "LastEvaluatedKey": listLast,
      });
    } else {
      param = jsonEncode(<dynamic, dynamic>{
        "user_id": Api.profile?.userId,
        "per_page": 500,
        "event_list": [1001, 10000, 10001],
      });
    }
    Api.post(context, Api.notify, param).then((value) => {
          if (value != null)
            {
              loadMore(value),
              listData.addAll(List.from(value['result'])
                  .map((a) => Noti.fromJson(a))
                  .toList()),
            }
          else
            {
              Utils.showAlertDialogEmpty(context),
            },
        });
  }

  loadMore(dynamic value) {
    List<LastEvaluatedKey> listLast = List.from(value['LastEvaluatedKey'])
        .map((a) => LastEvaluatedKey.fromJson(a))
        .toList();
    if (listLast.isNotEmpty) {
      getData(context, listLast);
    } else {
      isLoading = false;
      refresh();
      groupDriver();
    }
  }

  refresh() {
    setState(() {});
  }

  List<Noti> listDriver = [];

  groupDriver() {
    if (widget.name != null) {
      for (Noti n in listData) {
        print("${widget.name!}  ${n.driver_name!}");
        if (widget.name!.toLowerCase() == n.driver_name!.toLowerCase()) {
          listDriver.add(n);
        }
      }
    }
    if (listDriver.isEmpty) {
      Utils.showAlertDialogEmpty(context);
    }
    // else if (widget.license != null) {
    //   for (Noti n in listData) {
    //     // print(widget.name!+"  "+n.driver_name!);
    //     if (widget.license!.toLowerCase() == n.license!.toLowerCase()) {
    //       listDriver.add(n);
    //     }
    //   }
    // }

    groupSection();
  }

  List<NotiGroup> notiGroup = [];

  groupSection() {
    var groupByDate =
        groupBy(listDriver, (Noti obj) => Utils.convertDateToDay(obj.gpsdate));
    groupByDate.forEach((date, list) {
      // Header
      print('$date:');
      var group = NotiGroup();
      group.name = date;

      // Group
      for (var listItem in list) {
        // List item
        group.notifications.add(listItem);
        // print('${listItem.gpsdate}, ${listItem.location!.admin_level3_name}');
      }
      notiGroup.add(group);
      // day section divider
      // print('\n');
    });
  }

  showSort(BuildContext context) {
    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeCarSortPage(
        select: (i) {},
      ),
    );
  }

  showDetail() {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      // builder: (context) => HomeDriverDetailPage(),
      builder: (context) => Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            const BackIOS(),
            isLoading
                ? const CircularProgressIndicator(color: ColorCustom.primaryColor)
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: notiGroup.length,
                      itemBuilder: (BuildContext context, int index) {
                        NotiGroup group = notiGroup[index];
                        // Vehicle v = widget.listVehicle[index];

                        return Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      TimeAgo.timeAgoSinceDateNoti(group.name!),
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${group.notifications.length} ${Languages.of(context)!.unit_times}',
                                    style: const TextStyle(
                                      color: ColorCustom.primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              padding: const EdgeInsets.all(10),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: group.notifications.length,
                              itemBuilder: (BuildContext context, int index) {
                                Noti no = group.notifications[index];
                                // Vehicle v = widget.listVehicle[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                HomeNotiMapPage(noti: no)));
                                    // notiSelect = no;
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   HomeNotiMapPage.routeName,
                                    // );
                                    // Navigator.of(context)
                                    //     .pushNamedAndRemoveUntil(HomeNotiMapPage.routeName, (Route<dynamic> route) => false);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorCustom.greyBG2),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    no.vehicle_name!,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    no.vehicle!.info!
                                                        .licenseprov!,
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                no.driver_name!,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                no.location!,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // Text(
                                            //   Utils.convertDateToBase(no.gpsdate!),
                                            //   style: TextStyle(
                                            //     color: Colors.grey,
                                            //     fontSize: 12,
                                            //   ),
                                            // ),
                                            Text(
                                              no.display_gpsdate!,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Utils.eventIcon(no, context),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
