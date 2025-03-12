import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/event_group.dart';
import 'package:iov/model/history.dart';
import 'package:iov/model/trip.dart';
import 'package:iov/page/home_backup_event_search_map.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/back_ios.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeBackupEventSearchPage extends StatefulWidget {
  const HomeBackupEventSearchPage(
      {Key? key,
      required this.start,
      required this.end,
      required this.imei,
      required this.license,
      required this.timeStart,
      required this.timeEnd})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final DateTime start;
  final DateTime end;
  final String imei;
  final DateTime timeStart;
  final DateTime timeEnd;
  final String license;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeBackupEventSearchPage> {
  var start;

  var timeStart;

  var end;

  var timeEnd;
  int difference = 0;

  // int indexStart = 0;
  // int indexEnd = 0;

  @override
  void initState() {
    start = DateFormat('yyyy-MM-dd').format(widget.start);
    timeStart = DateFormat('HH:mm:ss').format(widget.timeStart);
    end = DateFormat('yyyy-MM-dd').format(widget.end);
    timeEnd = DateFormat('HH:mm:ss').format(widget.timeEnd);

    // getData(context);
    getData2(context);
    super.initState();
  }

  List<History> listHistory = [];

  getData(BuildContext context) {
    var param = jsonEncode(<dynamic, dynamic>{
      "start_date": start + " " + timeStart,
      "end_date": end + " " + timeEnd,
      "imei": widget.imei,
      "order_by": "Ascending",
      "LastEvaluatedKey": {},
      "NextTableName": "",
    });

    Api.post(context, Api.history, param).then((value) => {
          if (value != null)
            {
              if (value.containsKey("result"))
                {
                  listHistory = List.from(value['result']['vehicles'])
                      .map((a) => History.fromJson(a))
                      .toList(),
                  group(),
                  isLoad = false,
                  calDuration(listHistory[0].gpsdate!,
                      listHistory[listHistory.length - 1].gpsdate!),
                  refresh()
                }
              else
                {
                  isLoad = false,
                  refresh(),
                  Utils.showAlertDialog(context, "ไม่พบข้อมูล"),
                }
            }
          else
            {}
        });
  }

  List<Trip> data = [];

  String param = "";
  String vid = "";

  getData2(BuildContext context) {
    List list = [];
    vid = Utils.getVehicleByLicense(widget.license)!.info!.vid!.toString();

    final String param = Uri(
      queryParameters: {
        'user_id': Api.profile!.userId.toString(),
        'vid': vid,
        'start': '$start $timeStart',
        'end': '$end $timeEnd',
      },
    ).query;

    final String url = '${Api.trip}?$param';

    Api.get(context, url).then((value) => {
          if (value != null)
            {
              if (value.containsKey("result"))
                {
                  list = value["result"],
                  setData(list),
                  if (list.length <= 1)
                    {
                      Utils.showAlertDialogEmpty(context),
                    }
                }
            }
          else
            {isLoad = false, Utils.showAlertDialogEmpty(context), refresh()}
        });
  }

  //  showAlertDialog(BuildContext context,String title, String message) {
  //   // set up the button
  //   Widget okButton = FlatButton(
  //     child: Text("Go back"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(title),
  //     content: Text(message),
  //     actions: [
  //       okButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  setData(List a) {
    isLoad = false;
    for (var b in a) {
      if (b[13].isNotEmpty) {
        var t = Trip();
        t.data = b;
        data.add(t);
      }
    }
    // for (int i = 0; i < a.length; i++) {
    //   if (a[i][2] == 1) {
    //     indexStart = i;
    //     break;
    //   }
    // }
    // for (int i = indexStart; i < a.length; i++) {
    //   if (a[i][2] == 2000) {
    //     indexEnd = i;
    //     break;
    //   }
    // }
    // indexEnd = a.length-1;
    // print(indexStart);
    // print(indexEnd);
    group2();
    refresh();
  }

  String calTime(List<Trip> a) {
    DateTime aa = DateFormat('yyyy-MM-dd HH:mm:ss').parseLoose(a[0].data[0]);
    DateTime bb = DateFormat('yyyy-MM-dd HH:mm:ss').parseLoose(a[0].data[1]);
    var h = bb.difference(aa);
    var m = bb.difference(aa).inMinutes;
    var d = Duration(minutes: m);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    // return h.inMinutes.toStringAsFixed(0) + " ชม.";
    // return DateFormat('HH:mm').format(date);
  }

  String calDistance(List<Trip> a) {
    double sum = 0;
    for (int i = 0; i < a.length - 1; i++) {
      Trip b = a[i];
      if (b.data[9] is double) {
        sum += b.data[9] as double;
      } else {
        sum += b.data[9] as int;
      }
    }
    return "${Utils.numberFormat(sum)} ${Languages.of(context)!.km}";
  }

  String calFuel(List<Trip> a) {
    double sum = 0;
    for (int i = 0; i < a.length - 1; i++) {
      Trip b = a[i];
      if (b.data[10] is double) {
        sum += b.data[10] as double;
      } else {
        sum += b.data[10] as int;
      }
    }
    return "${Utils.numberFormat(sum)} ${Languages.of(context)!.lite}";
  }

  String calFuelCon(List<Trip> a) {
    double sum = 0;
    for (int i = 0; i < a.length - 1; i++) {
      Trip b = a[i];
      if (b.data[11] is double) {
        sum += b.data[11] as double;
      } else {
        sum += b.data[11] as int;
      }
    }
    return "${Utils.numberFormat(sum)} ${Languages.of(context)!.km_l}";
  }

  calDuration(String start, String end) {
    DateTime aa = DateFormat('yyyy-MM-dd HH:mm:ss').parseLoose(start);
    DateTime bb = DateFormat('yyyy-MM-dd HH:mm:ss').parseLoose(end);
    var h = bb.difference(aa);
    var m = bb.difference(aa).inMinutes;
    difference = h.inHours;
  }

  String displayDate(
      DateTime start, DateTime end, DateTime timeStart, DateTime timeEnd) {
    return "${DateFormat('dd MMM yy', Api.language).format(start)} ${DateFormat('HH:mm').format(timeStart)} - ${DateFormat('dd MMM yy', Api.language).format(end)} ${DateFormat('HH:mm').format(timeEnd)}";
  }

  List<EventGroup> listEvent = [];

  group() {
    var groupByDate =
        groupBy(listHistory, (History obj) => obj.gpsdate!.substring(0, 10));
    groupByDate.forEach((date, list) {
      // Header
      // print('${date}:');
      var group = EventGroup();
      group.date = date;

      // Group
      for (var listItem in list) {
        // List item
        group.history.add(listItem);
        // print('${listItem.gpsdate}, ${listItem.location!.admin_level3_name}');
      }
      listEvent.add(group);
    });
  }

  List<EventGroup> listEvent2 = [];

  group2() {
    // var groupByDate = groupBy(data, (Trip obj) => obj.data[13]);
    // groupByDate.forEach((date, list) {
    //   // Header
    //   print('${date}:');
    //   var group = new EventGroup();
    //   group.date = date;
    //
    //   // Group
    //   list.forEach((listItem) {
    //     // List item
    //     group.trips.add(listItem);
    //   });
    //   listEvent2.add(group);
    // });

    int start = -1;
    int end = -1;
    for (int i = 0; i < data.length; i++) {
      if (data[i].data[2] == 1) {
        start = i;
      }
      if (start != -1) {
        if (data[i].data[2] == 2000) {
          var group = EventGroup();
          group.date = "";
          end = i;
          group.trips.addAll(data.sublist(start, end + 1));
          // print(group.trips.length);
          // print(group.trips[0].data[3]);
          // print(group.trips[group.trips.length-1].data[3]);
          listEvent2.add(group);
          // print(start);
          // print(end);

          start = -1;
        }
      }
    }
  }

  bool isLoad = true;

  refresh() {
    setState(() {});
  }

  launchMap(double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  distanceCal(double start, double stop) {
    return Utils.numberFormat(stop - start);
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
      backgroundColor: Colors.black,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackIOS(),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorCustom.greyBG2),
                        color: ColorCustom.greyBG2,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              displayDate(widget.start, widget.end,
                                  widget.timeStart, widget.timeEnd),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: listEvent2.length,
                        itemBuilder: (BuildContext context, int index) {
                          var event = listEvent2[index];

                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCustom.greyBG2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.restore,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            Expanded(
                                              child: Text(
                                                Languages.of(context)!
                                                    .event_log,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            InkWell(
                                              child: Image.asset(
                                                "assets/images/google-maps.png",
                                                width: 30,
                                                height: 30,
                                              ),
                                              onTap: () {
                                                var s = event.trips[0].data[0];
                                                var e = event
                                                    .trips[
                                                        event.trips.length - 1]
                                                    .data[1];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            HomeBackupEventSearchMapPage(
                                                              list: event.trips,
                                                              vid: vid,
                                                              timeStart: s,
                                                              timeEnd: e,
                                                            )));
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/timeline.png",
                                              width: 40,
                                              height: 80,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    Languages.of(context)!
                                                        .event_driving,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    event.trips[0].data[3],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    Languages.of(context)!
                                                        .event_ign_off,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    event
                                                        .trips[
                                                            event.trips.length -
                                                                1]
                                                        .data[3],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  event.isExpand
                                      ? Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_date_time,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                "${Utils.convertDateToBaseReal(event.trips[0].data[21])} - ${Utils.convertDateToBaseReal(event.trips[0].data[22])}",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_duration,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                calTime(event.trips),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_obd_start,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                Utils.numberFormat(
                                                    event.trips[0].data[19]),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_obd_end,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                Utils.numberFormat(event
                                                    .trips[
                                                        event.trips.length - 1]
                                                    .data[20]),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_distance,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                calDistance(event.trips),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_fuel,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                calFuel(event.trips),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_fuel_consumption,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                calFuelCon(event.trips),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Languages.of(context)!
                                                    .event_driver,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                (event.trips[0].data[4]
                                                            as String)
                                                        .isEmpty
                                                    ? Languages.of(context)!
                                                        .unidentified_driver
                                                    : event.trips[0].data[4],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                          color: ColorCustom.greyBG2,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          )),
                                      padding: const EdgeInsets.all(5),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (event.isExpand) {
                                              event.isExpand = false;
                                            } else {
                                              event.isExpand = true;
                                            }
                                          });
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              event.isExpand
                                                  ? Languages.of(context)!.less
                                                  : Languages.of(context)!.more,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Icon(
                                              event.isExpand
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              size: 20,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              isLoad
                  ? const CircularProgressIndicator(
                      color: ColorCustom.primaryColor)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
