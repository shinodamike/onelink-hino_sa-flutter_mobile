// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:group_button/group_button.dart';
// import 'package:hino/api/api.dart';
// import 'package:hino/model/dropdown.dart';
// import 'package:hino/model/event_group.dart';
// import 'package:hino/model/history.dart';
// import 'package:hino/model/member.dart';
// import 'package:hino/model/truck.dart';
// import 'package:hino/page/home_backup_event_search_map.dart';
// import 'package:hino/page/home_backup_event_search_video.dart';
// import 'package:hino/page/home_car_filter.dart';
// import 'package:hino/page/home_detail.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/utils/responsive.dart';
// import 'package:hino/utils/utils.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:hino/widget/dropbox_general_search.dart';
// import 'package:hino/widget/fancy_fab.dart';
// import 'package:intl/intl.dart';
//
// import 'dart:ui' as ui;
//
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'home_car_sort.dart';
//
// class HomeBackupEventSearchPage extends StatefulWidget {
//   const HomeBackupEventSearchPage(
//       {Key? key,
//       required this.start,
//       required this.end,
//       required this.imei,
//       required this.license,
//       required this.timeStart,
//       required this.timeEnd})
//       : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//   final DateTime start;
//   final DateTime end;
//   final String imei;
//   final DateTime timeStart;
//   final DateTime timeEnd;
//   final String license;
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeBackupEventSearchPage> {
//   var start;
//
//   var timeStart;
//
//   var end;
//
//   var timeEnd;
//   int difference = 0;
//
//   @override
//   void initState() {
//     start = DateFormat('yyyy-MM-dd').format(widget.start);
//     timeStart = DateFormat('HH:mm:ss').format(widget.timeStart);
//     end = DateFormat('yyyy-MM-dd').format(widget.end);
//     timeEnd = DateFormat('HH:mm:ss').format(widget.timeEnd);
//
//     // getData(context);
//     getData2(context);
//     super.initState();
//   }
//
//   List<History> listHistory = [];
//
//   getData(BuildContext context) {
//     var param = jsonEncode(<dynamic, dynamic>{
//       "start_date": start + " " + timeStart,
//       "end_date": end + " " + timeEnd,
//       "imei": widget.imei,
//       "order_by": "Ascending",
//       "LastEvaluatedKey": {},
//       "NextTableName": "",
//     });
//
//     Api.post(context, Api.history, param).then((value) => {
//           if (value != null)
//             {
//               if (value.containsKey("result"))
//                 {
//                   listHistory = List.from(value['result']['vehicles'])
//                       .map((a) => History.fromJson(a))
//                       .toList(),
//                   group(),
//                   isLoad = false,
//                   calDuration(listHistory[0].gpsdate!,
//                       listHistory[listHistory.length - 1].gpsdate!),
//                   refresh()
//                 }
//               else
//                 {
//                   isLoad = false,
//                   refresh(),
//                   Utils.showAlertDialog(context, "ไม่พบข้อมูล"),
//                 }
//             }
//           else
//             {}
//         });
//   }
//   List data = [];
//   getData2(BuildContext context) {
//
//     var a = Utils.getVehicleByLicense(widget.license)!.info!.vid!;
//     Api.get(
//             context,
//             Api.trip +
//                 "?user_id=" +
//                 Api.profile!.userId.toString() +
//                 "&vid=" +
//                 a.toString() +
//                 "&start=" +
//                 start +
//                 " " +
//                 timeStart +
//                 "&end=" +
//                 end +
//                 " " +
//                 timeEnd)
//         .then((value) => {
//               if (value != null) {data = value["result"]} else {}
//             });
//   }
//
//   calDuration(String start, String end) {
//     DateTime aa = DateFormat('yyyy-MM-dd HH:mm:ss').parseLoose(start);
//     DateTime bb = DateFormat('yyyy-MM-dd HH:mm:ss').parseLoose(end);
//     var h = bb.difference(aa);
//     var m = bb.difference(aa).inMinutes;
//     difference = h.inHours;
//   }
//
//   String displayDate(
//       DateTime start, DateTime end, DateTime timeStart, DateTime timeEnd) {
//     return DateFormat('dd MMM yy').format(start) +
//         " " +
//         DateFormat('HH:mm').format(timeStart) +
//         " - " +
//         DateFormat('dd MMM yy').format(end) +
//         " " +
//         DateFormat('HH:mm').format(timeEnd);
//   }
//
//   List<EventGroup> listEvent = [];
//
//   group() {
//     var groupByDate =
//         groupBy(listHistory, (History obj) => obj.gpsdate!.substring(0, 10));
//     groupByDate.forEach((date, list) {
//       // Header
//       print('${date}:');
//       var group = new EventGroup();
//       group.date = date;
//
//       // Group
//       list.forEach((listItem) {
//         // List item
//         group.history.add(listItem);
//         print('${listItem.gpsdate}, ${listItem.location!.admin_level3_name}');
//       });
//       listEvent.add(group);
//       // day section divider
//       print('\n');
//     });
//   }
//
//   bool isLoad = true;
//
//   refresh() {
//     setState(() {});
//   }
//
//   launchMap(double lat, double long) async {
//     String googleUrl =
//         'https://www.google.com/maps/search/?api=1&query=$lat,$long';
//     if (await canLaunch(googleUrl)) {
//       await launch(googleUrl);
//     } else {
//       throw 'Could not open the map.';
//     }
//   }
//
//   distanceCal(double start, double stop) {
//     return Utils.numberFormat(stop - start);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: _goToMe,
//       //   label: Text('My location'),
//       //   icon: Icon(Icons.near_me),
//       // ),
//       body: SafeArea(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   BackIOS(),
//                   Container(
//                     margin: EdgeInsets.only(top: 10),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: ColorCustom.greyBG2),
//                       color: ColorCustom.greyBG2,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(15.0),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Icon(
//                           Icons.calendar_today,
//                           size: 20,
//                           color: Colors.black,
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: Text(
//                             displayDate(widget.start, widget.end,
//                                 widget.timeStart, widget.timeEnd),
//                             style: TextStyle(color: Colors.black, fontSize: 16),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       shrinkWrap: false,
//                       itemCount: data.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         var event = data[index];
//
//                         return GestureDetector(
//                           onTap: () {},
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: ColorCustom.greyBG2),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(10.0),
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(10),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.restore,
//                                             size: 20,
//                                             color: Colors.grey,
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               "เหตุการณ์ย้อนหลัง",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 18),
//                                             ),
//                                           ),
//                                           InkWell(
//                                             child: Image.asset(
//                                               "assets/images/google-maps.png",
//                                               width: 30,
//                                               height: 30,
//                                             ),
//                                             onTap: () {
//                                               // Navigator.push(
//                                               //     context,
//                                               //     MaterialPageRoute(
//                                               //         builder: (_) =>
//                                               //             HomeBackupEventSearchMapPage(
//                                               //               list: event.history,
//                                               //             )));
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Image.asset(
//                                             "assets/images/timeline.png",
//                                             width: 40,
//                                             height: 80,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "เริ่มเดินทาง",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14),
//                                               ),
//                                               Text(
//                                                 event.history[0].location!
//                                                         .admin_level3_name! +
//                                                     " " +
//                                                     event.history[0].location!
//                                                         .admin_level2_name! +
//                                                     " " +
//                                                     event.history[0].location!
//                                                         .admin_level1_name!,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Text(
//                                                 "สิ้นสุดการเดินทาง",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14),
//                                               ),
//                                               Text(
//                                                 event
//                                                         .history[event.history
//                                                                 .length -
//                                                             1]
//                                                         .location!
//                                                         .admin_level3_name! +
//                                                     " " +
//                                                     event
//                                                         .history[event.history
//                                                                 .length -
//                                                             1]
//                                                         .location!
//                                                         .admin_level2_name! +
//                                                     " " +
//                                                     event
//                                                         .history[event.history
//                                                                 .length -
//                                                             1]
//                                                         .location!
//                                                         .admin_level1_name!,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 event.isExpand
//                                     ? Container(
//                                         padding: EdgeInsets.all(10),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Text(
//                                               "วัน/เวลา",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14),
//                                             ),
//                                             Text(
//                                               Utils.convertDateToBase(event
//                                                       .history[0].gpsdate!) +
//                                                   " - " +
//                                                   Utils.convertDateToBase(event
//                                                       .history[
//                                                           event.history.length -
//                                                               1]
//                                                       .gpsdate!),
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               "ระยะเวลาในการขับขี่",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14),
//                                             ),
//                                             Text(
//                                               difference.toString() + " ชม.",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               "เลขไมล์สิ้นสุด",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14),
//                                             ),
//                                             Text(
//                                               Utils.numberFormat(event
//                                                   .history[
//                                                       event.history.length - 1]
//                                                   .mileage!),
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               "ระยะทางสะสม",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14),
//                                             ),
//                                             Text(
//                                               distanceCal(
//                                                   event.history[0].mileage!,
//                                                   event
//                                                       .history[
//                                                           event.history.length -
//                                                               1]
//                                                       .mileage!),
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             // SizedBox(
//                                             //   height: 5,
//                                             // ),
//                                             // Text(
//                                             //   "อัตราการใช้น้ำมัน",
//                                             //   style: TextStyle(
//                                             //       color: Colors.black,
//                                             //       fontSize: 14),
//                                             // ),
//                                             // Text(
//                                             //   "39 ลิตร",
//                                             //   style: TextStyle(
//                                             //       color: Colors.black,
//                                             //       fontSize: 14,
//                                             //       fontWeight: FontWeight.bold),
//                                             // ),
//                                             // SizedBox(
//                                             //   height: 5,
//                                             // ),
//                                             // Text(
//                                             //   "อัตราสิ้นเปลือง",
//                                             //   style: TextStyle(
//                                             //       color: Colors.black,
//                                             //       fontSize: 14),
//                                             // ),
//                                             // Text(
//                                             //   "31 กม./ล",
//                                             //   style: TextStyle(
//                                             //       color: Colors.black,
//                                             //       fontSize: 14,
//                                             //       fontWeight: FontWeight.bold),
//                                             // ),
//                                             // SizedBox(
//                                             //   height: 5,
//                                             // ),
//                                             // Text(
//                                             //   "คนขับรถ",
//                                             //   style: TextStyle(
//                                             //       color: Colors.black,
//                                             //       fontSize: 14),
//                                             // ),
//                                             // Text(
//                                             //   "Mr. Loylum Bunnag",
//                                             //   style: TextStyle(
//                                             //       color: Colors.black,
//                                             //       fontSize: 14,
//                                             //       fontWeight: FontWeight.bold),
//                                             // ),
//                                           ],
//                                         ),
//                                       )
//                                     : Container(),
//                                 Container(
//                                     alignment: Alignment.center,
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                         color: ColorCustom.greyBG2,
//                                         borderRadius: BorderRadius.only(
//                                           bottomRight: Radius.circular(10.0),
//                                           bottomLeft: Radius.circular(10.0),
//                                         )),
//                                     padding: EdgeInsets.all(5),
//                                     child: InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           if (event.isExpand) {
//                                             event.isExpand = false;
//                                           } else {
//                                             event.isExpand = true;
//                                           }
//                                         });
//                                       },
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             event.isExpand
//                                                 ? 'น้อยลง'
//                                                 : "เพิ่มเติม",
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           Icon(
//                                             event.isExpand
//                                                 ? Icons.expand_less
//                                                 : Icons.expand_more,
//                                             size: 20,
//                                             color: Colors.black,
//                                           )
//                                         ],
//                                       ),
//                                     )),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             isLoad ? CircularProgressIndicator() : Container()
//           ],
//         ),
//       ),
//     );
//   }
// }
