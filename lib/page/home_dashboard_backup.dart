// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hino/api/api.dart';
// import 'package:hino/model/chart_data.dart';
// import 'package:hino/model/dashboard.dart';
// import 'package:hino/model/dashboard_data.dart';
// import 'package:hino/model/dashboard_driver.dart';
// import 'package:hino/model/dashboard_realtime.dart';
// import 'package:hino/model/driver_detail.dart';
// import 'package:hino/model/eco.dart';
// import 'package:hino/model/safety.dart';
// import 'package:hino/model/truck.dart';
// import 'package:hino/model/vehicle.dart';
// import 'package:hino/page/dashboard_filter.dart';
// import 'package:hino/page/home_car_filter.dart';
// import 'package:hino/page/home_detail.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/utils/responsive.dart';
// import 'package:hino/utils/utils.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:hino/widget/dateview_range_custom.dart';
// import 'package:hino/widget/dateview_range_custom2.dart';
// import 'package:hino/widget/fancy_fab.dart';
// import 'package:intl/intl.dart';
//
// import 'dart:ui' as ui;
//
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:radar_chart/radar_chart.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// import 'home_car_sort.dart';
// import 'home_driver_detail.dart';
//
// class HomeDashboardPage extends StatefulWidget {
//   const HomeDashboardPage({
//     Key? key,
//   }) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the S
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeDashboardPage>
//     with SingleTickerProviderStateMixin {
//   Timer? timer;
//
//   @override
//   void initState() {
//     getData(context);
//     getDataRealtime(context);
//     getDataDriver(context);
//     timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
//       getDataRealtime(context);
//       getDataDriver(context);
//     });
//     tabController = TabController(vsync: this, length: 2);
//     tabController?.addListener(() {
//       print("asdasd");
//       indexTab = tabController!.index;
//       refresh();
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   List listVid = [];
//
//   Dashboard? dashboard;
//   List<DashboardData> dashboardDatas = [];
//   int drive = 0;
//   int parking = 0;
//   int idle = 0;
//   int offline = 0;
//   int sum = 0;
//   TextEditingController dateEditController = new TextEditingController();
//
//   getData(BuildContext context) {
//     drive = 0;
//     parking = 0;
//     idle = 0;
//     offline = 0;
//     sum = 0;
//     var a = DateFormat('yyyy-MM-dd').format(start);
//     var b = DateFormat('yyyy-MM-dd').format(to);
//     // dateEditController.text = a + " - " + b;
//     var param = jsonEncode(<dynamic, dynamic>{
//       "start_date": a,
//       "stop_date": b,
//       "vid_list": listVid
//     });
//     Api.post(context, Api.dashboard_summary, param).then((value) => {
//           if (value != null)
//             {
//               // dashboard = Dashboard.fromJson(value["result"]),
//               // value['result'].forEach((v) {
//               //   if (v is List<dynamic>) {
//               //     print("List");
//               //   } else {
//               //     // Map<String, dynamic>
//               //     print("Map");
//               //   }
//               //   dashboardDatas.add(DashboardData.fromJson(v));
//               // }),
//               dashboard = Dashboard.fromJson(value['result']["summary"]),
//               initChart(dashboard!),
//               dashboardDatas = List.from(value['result']["date"])
//                   .map((a) => DashboardData.fromJson(a))
//                   .toList(),
//               dashboardDatas.removeRange(7, dashboardDatas.length),
//
//               for (DashboardData data in dashboardDatas)
//                 {
//                   drive += data.driv!,
//                   parking += data.park!,
//                   idle += data.idle!,
//                   offline += data.offline!,
//                 },
//               sum = drive + parking + idle + offline,
//
//               refresh(),
//             }
//           else
//             {}
//         });
//   }
//
//   List<ChartData> listCircle = [];
//   DashboardRealtime? dashboardRealtime;
//   int sumRealtime = 0;
//
//   getDataRealtime(BuildContext context) {
//     sumRealtime = 0;
//     listCircle.clear();
//     Api.get(context, Api.dashboard_realtime).then((value) => {
//           if (value != null)
//             {
//               dashboardRealtime = DashboardRealtime.fromJson(value["result"]),
//               listCircle.add(ChartData(
//                   name: dashboardRealtime!.ioNameDriving,
//                   value: dashboardRealtime!.unitDriving!,
//                   color: hexToColor(dashboardRealtime!.ioColorDriving!))),
//               listCircle.add(ChartData(
//                   name: dashboardRealtime!.ioNameParking,
//                   value: dashboardRealtime!.unitParking!,
//                   color: hexToColor(dashboardRealtime!.ioColorParking!))),
//               listCircle.add(ChartData(
//                   name: dashboardRealtime!.ioNameIdling,
//                   value: dashboardRealtime!.unitIdling!,
//                   color: hexToColor(dashboardRealtime!.ioColorIdling!))),
//               listCircle.add(ChartData(
//                   name: dashboardRealtime!.ioNameOverspeed,
//                   value: dashboardRealtime!.unitOverspeed!,
//                   color: hexToColor(dashboardRealtime!.ioColorOverspeed!))),
//               listCircle.add(ChartData(
//                   name: dashboardRealtime!.ioNameOffline,
//                   value: dashboardRealtime!.unitOffline!,
//                   color: hexToColor(dashboardRealtime!.ioColorOffline!))),
//               sumRealtime = dashboardRealtime!.unitDriving! +
//                   dashboardRealtime!.unitParking! +
//                   dashboardRealtime!.unitIdling! +
//                   dashboardRealtime!.unitOverspeed! +
//                   dashboardRealtime!.unitOffline!,
//               refresh(),
//             }
//           else
//             {}
//         });
//   }
//
//   Color hexToColor(String code) {
//     return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
//   }
//
//   DashboardDriver? dashboardDriver;
//   List<ChartData> listCircleDriver = [];
//   int sumDriver = 0;
//
//   getDataDriver(BuildContext context) {
//     listCircleDriver.clear();
//     Api.get(context, Api.dashboard_driver).then((value) => {
//           if (value != null)
//             {
//               dashboardDriver = DashboardDriver.fromJson(value["result"]),
//               listCircleDriver.add(ChartData(
//                   name: dashboardDriver!.ioNameSwipecard,
//                   value: dashboardDriver!.unitSwipecard,
//                   color: hexToColor(dashboardDriver!.ioColorSwipecard!))),
//               listCircleDriver.add(ChartData(
//                   name: dashboardDriver!.ioNameNotSwipecard,
//                   value: dashboardDriver!.unitNotSwipecard,
//                   color: hexToColor(dashboardDriver!.ioColorNotSwipecard!))),
//               listCircleDriver.add(ChartData(
//                   name: dashboardDriver!.ioNameValidate,
//                   value: dashboardDriver!.unitValidate,
//                   color: hexToColor(dashboardDriver!.ioColorValidate!))),
//               sumDriver = dashboardDriver!.unitValidate! +
//                   dashboardDriver!.unitNotSwipecard! +
//                   dashboardDriver!.unitSwipecard!,
//               refresh(),
//             }
//           else
//             {}
//         });
//   }
//
//   refresh() {
//     setState(() {});
//   }
//
//   List<String> features = [];
//   List<double> avg = [];
//   List<double> point = [];
//
//   List<String> features2 = [];
//   List<double> avg2 = [];
//   List<double> point2 = [];
//
//   var start = DateTime.now().subtract(Duration(
//     days: 7,
//   ));
//   var to = DateTime.now();
//
//   double sumPoint = 0;
//   double sumPoint2 = 0;
//
//   initChart(Dashboard dashboard) {
//      sumPoint = 0;
//      sumPoint2 = 0;
//     features = [];
//     avg = [];
//     point = [];
//
//     features2 = [];
//     avg2 = [];
//     point2 = [];
//     for (Eco eco in dashboard.eco) {
//       features.add(eco.arg!);
//       avg.add(eco.avg! / 5);
//       point.add(eco.point! / 5);
//       sumPoint+=eco.avg!;
//     }
//
//     for (Safety safe in dashboard.safety) {
//       features2.add(safe.arg!);
//       avg2.add(safe.avg! / 5);
//       point2.add(safe.point! / 5);
//       sumPoint2+=safe.avg!;
//     }
//   }
//
//   var ticksss = [7, 14, 21, 28, 35];
//   var featuresss = ["AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH"];
//   var datass = [
//     [10, 20, 28, 5, 16, 15, 17, 6],
//     [15, 1, 4, 14, 23, 10, 6, 19]
//   ];
//
//   showDia(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Center(
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 margin:
//                     EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
//                 color: Colors.white,
//                 child: DashboardFilter(
//                   data: (List<Vehicle> value) {
//                     for (Vehicle v in value) {
//                       listVid.add(v.info!.vid!);
//                     }
//                     getData(context);
//                   },
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   int indexTab = 0;
//
//   TabController? tabController;
//
//   Widget _tabSection(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(10),
//             color: Colors.white,
//             child: TabBar(
//               controller: tabController,
//               tabs: [
//                 Tab(text: "ภาพรวม"),
//                 Tab(text: "ภาพรวมข้อมูลล่าสุด"),
//               ],
//               indicatorColor: ColorCustom.primaryAssentColor,
//               labelColor: Colors.black,
//               unselectedLabelColor: Colors.grey,
//               labelStyle: GoogleFonts.kanit(),
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: tabController,
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       dashboard != null
//                           ? Container(
//                               padding: EdgeInsets.all(10),
//                               margin: EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: ColorCustom.greyBG2),
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10.0),
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.near_me,
//                                         size: 50,
//                                         color: Colors.grey,
//                                       ),
//                                       Text(
//                                         'การใช้ประโยชน์รถ',
//                                         style: TextStyle(
//                                           color: ColorCustom.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   SfCartesianChart(
//                                       // primaryXAxis: CategoryAxis(),
//                                       // Chart title
//                                       // title: ChartTitle(text: 'Half yearly sales analysis'),
//                                       // Enable legend
//                                       legend: Legend(isVisible: false),
//                                       // Enable tooltip
//                                       axisLabelFormatter:
//                                           (axisLabelRenderArgs) {
//                                         var text = "";
//                                         if (axisLabelRenderArgs.axisName ==
//                                             "primaryYAxis") {
//                                           text = axisLabelRenderArgs.text;
//                                           if (axisLabelRenderArgs.value == 0) {
//                                             text = "0 ชม.";
//                                           } else if (axisLabelRenderArgs
//                                                   .value ==
//                                               20) {
//                                             text = "4 ชม.";
//                                           } else if (axisLabelRenderArgs
//                                                   .value ==
//                                               40) {
//                                             text = "8 ชม.";
//                                           } else if (axisLabelRenderArgs
//                                                   .value ==
//                                               60) {
//                                             text = "12 ชม.";
//                                           } else if (axisLabelRenderArgs
//                                                   .value ==
//                                               80) {
//                                             text = "18 ชม.";
//                                           } else if (axisLabelRenderArgs
//                                                   .value ==
//                                               100) {
//                                             text = "24 ชม.";
//                                           }
//                                         } else {
//                                           text = Utils.getDateGraph(
//                                               axisLabelRenderArgs.text);
//                                         }
//                                         ChartAxisLabel a = new ChartAxisLabel(
//                                           text,
//                                           TextStyle(
//                                             color: ColorCustom.black,
//                                             fontSize: 10,
//                                           ),
//                                         );
//                                         return a;
//                                       },
//                                       primaryXAxis: CategoryAxis(
//                                         majorGridLines:
//                                             const MajorGridLines(width: 0),
//                                       ),
//                                       primaryYAxis: NumericAxis(
//                                           rangePadding: ChartRangePadding.none,
//                                           axisLine: const AxisLine(width: 0),
//                                           majorTickLines:
//                                               const MajorTickLines(size: 0)),
//                                       // tooltipBehavior:
//                                       //     TooltipBehavior(enable: true),
//                                       tooltipBehavior: TooltipBehavior(
//                                           enable: true,
//                                           shouldAlwaysShow: true,
//                                           // Templating the tooltip
//                                           builder: (dynamic data,
//                                               dynamic point,
//                                               dynamic series,
//                                               int pointIndex,
//                                               int seriesIndex) {
//                                             // print("data "+data);
//                                             // print("series "+series);
//                                             int s = data.driv +
//                                                 data.park +
//                                                 data.idle +
//                                                 data.offline;
//                                             var a = " วิ่ง " +
//                                                 Utils.numberFormatInt(
//                                                     data.driv) +
//                                                 " h : " +
//                                                 (data.driv * 100 / s)
//                                                     .toStringAsFixed(1) +
//                                                 " % ";
//                                             var b = " ดับเครื่อง " +
//                                                 Utils.numberFormatInt(
//                                                     data.park) +
//                                                 " h : " +
//                                                 (data.park * 100 / s)
//                                                     .toStringAsFixed(1) +
//                                                 " % ";
//                                             var c = " จอดไม่ดับเครื่อง " +
//                                                 Utils.numberFormatInt(
//                                                     data.idle) +
//                                                 " h : " +
//                                                 (data.idle * 100 / s)
//                                                     .toStringAsFixed(1) +
//                                                 " % ";
//                                             var d = " ไม่ส่งข้อมูล " +
//                                                 Utils.numberFormatInt(
//                                                     data.offline) +
//                                                 " h : " +
//                                                 (data.offline * 100 / s)
//                                                     .toStringAsFixed(1) +
//                                                 " % ";
//
//                                             return Container(
//                                               child: Text(
//                                                 a +
//                                                     "\n" +
//                                                     b +
//                                                     "\n" +
//                                                     c +
//                                                     "\n" +
//                                                     d,
//                                                 style: TextStyle(
//                                                   color: ColorCustom.white,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                       series: <
//                                           ChartSeries<DashboardData, String>>[
//                                         StackedColumn100Series<DashboardData,
//                                                 String>(
//                                             color: Colors.green,
//                                             dataSource: dashboardDatas,
//                                             xValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.display_datetime,
//                                             yValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.driv,
//                                             name: 'วิ่ง',
//                                             // Enable data label
//                                             dataLabelSettings:
//                                                 DataLabelSettings(
//                                                     isVisible: false)),
//                                         StackedColumn100Series<DashboardData,
//                                                 String>(
//                                             color: Colors.red,
//                                             dataSource: dashboardDatas,
//                                             xValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.display_datetime,
//                                             yValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.park,
//                                             name: 'ดับเครื่อง',
//                                             // Enable data label
//                                             dataLabelSettings:
//                                                 DataLabelSettings(
//                                                     isVisible: false)),
//                                         StackedColumn100Series<DashboardData,
//                                                 String>(
//                                             color: Colors.orange,
//                                             dataSource: dashboardDatas,
//                                             xValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.display_datetime,
//                                             yValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.idle,
//                                             name: 'จอดไม่ดับเครื่อง',
//                                             // Enable data label
//                                             dataLabelSettings:
//                                                 DataLabelSettings(
//                                                     isVisible: false)),
//                                         StackedColumn100Series<DashboardData,
//                                                 String>(
//                                             color: Colors.grey,
//                                             dataSource: dashboardDatas,
//                                             xValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.display_datetime,
//                                             yValueMapper:
//                                                 (DashboardData sales, _) =>
//                                                     sales.offline,
//                                             name: 'ออฟไลน์',
//                                             // Enable data label
//                                             dataLabelSettings:
//                                                 DataLabelSettings(
//                                                     isVisible: false))
//                                       ]),
//                                 ],
//                               ),
//                             )
//                           : Container(),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Icon(
//                             Icons.circle,
//                             size: 15,
//                             color: Colors.green,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             'วิ่ง',
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Text(
//                             Utils.numberFormatInt(drive) +
//                                 " h : " +
//                                 (drive * 100 / sum).toStringAsFixed(1) +
//                                 " %",
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Icon(
//                             Icons.circle,
//                             size: 15,
//                             color: Colors.red,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             'ดับเครื่อง',
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Text(
//                             Utils.numberFormatInt(parking) +
//                                 " h : " +
//                                 (parking * 100 / sum).toStringAsFixed(1) +
//                                 " %",
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Icon(
//                             Icons.circle,
//                             size: 15,
//                             color: Colors.orange,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             'จอดไม่ดับเครื่อง',
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Text(
//                             Utils.numberFormatInt(idle) +
//                                 " h : " +
//                                 (idle * 100 / sum).toStringAsFixed(1) +
//                                 " %",
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Icon(
//                             Icons.circle,
//                             size: 15,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             'ออฟไลน์',
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Text(
//                             Utils.numberFormatInt(offline) +
//                                 " h : " +
//                                 (offline * sum / 100).toString() +
//                                 " %",
//                             style: TextStyle(
//                               color: ColorCustom.black,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//
//
//
//                       Container(
//                         padding: EdgeInsets.all(10),
//                         margin: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: ColorCustom.greyBG2),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10.0),
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.spa,
//                                   size: 50,
//                                   color: Colors.grey,
//                                 ),
//                                 Text(
//                                   'การขับขี่แบบประหยัด'+" ("+((sumPoint * 100)/30).toStringAsFixed(0)+"/100)",
//                                   style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             // Container(
//                             //   width: 200,
//                             //   height: 200,
//                             //   child: RadarChart.light(
//                             //     ticks: ticks,
//                             //     features: features,
//                             //     data: data,
//                             //     reverseAxis: true,
//                             //     useSides: true,
//                             //   ),
//                             // ),
//                             avg.isEmpty
//                                 ? Container()
//                                 : RadarChart(
//                                     length: avg.length,
//                                     radius: 100,
//                                     backgroundColor: Colors.white,
//                                     initialAngle: pi / 6,
//                                     borderStroke: 2,
//                                     borderColor: Colors.grey.shade300,
//                                     radialStroke: 1,
//                                     radialColor: Colors.grey.shade300,
//                                     vertices: [
//                                       for (int i = 0; i < features.length; i++)
//                                         RadarVertex(
//                                           radius: 20,
//                                           text: Text(
//                                             Utils.mapEcoName(features[i]),
//                                             style: TextStyle(
//                                               color: ColorCustom.black,
//                                               fontSize: 10,
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                     radars: [
//                                       RadarTile(
//                                         values: point,
//                                         borderStroke: 2,
//                                         backgroundColor:
//                                             Colors.red.withOpacity(0.4),
//                                       ),
//                                       RadarTile(
//                                         values: avg,
//                                         borderStroke: 2,
//                                         backgroundColor:
//                                             Colors.greenAccent.withOpacity(0.4),
//                                       ),
//                                     ],
//                                   ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.fiber_manual_record,
//                                   size: 15,
//                                   color: ColorCustom.dashboard_save,
//                                 ),
//                                 Text(
//                                   "ค่าเฉลี่ย",
//                                   style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.fiber_manual_record,
//                                   size: 15,
//                                   color: ColorCustom.dashboard_save2,
//                                 ),
//                                 Text(
//                                   "คะแนน",
//                                   style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             // Image.asset("assets/images/driver_graph.png"),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(10),
//                         margin: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: ColorCustom.greyBG2),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10.0),
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.admin_panel_settings,
//                                   size: 50,
//                                   color: Colors.grey,
//                                 ),
//                                 Text(
//                                   'การขับขี่แบบปลอดภัย'+" ("+((sumPoint2 * 100)/30).toStringAsFixed(0)+"/100)",
//                                   style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             avg2.isEmpty
//                                 ? Container()
//                                 : RadarChart(
//                                     length: avg2.length,
//                                     radius: 100,
//                                     initialAngle: pi / 6,
//                                     backgroundColor: Colors.white,
//                                     borderStroke: 2,
//                                     borderColor: Colors.grey.shade300,
//                                     radialStroke: 1,
//                                     radialColor: Colors.grey.shade300,
//                                     vertices: [
//                                       for (int i = 0; i < features2.length; i++)
//                                         RadarVertex(
//
//                                           radius: 15,
//                                           textOffset: Offset(0.5, 0.5),
//                                           text: Text(
//                                             Utils.mapSafetyName(features2[i]),
//                                             style: TextStyle(
//                                               color: ColorCustom.black,
//                                               fontSize: 10,
//                                             ),
//
//                                           ),
//
//                                         ),
//                                     ],
//                                     radars: [
//                                       RadarTile(
//                                         values: point2,
//                                         borderStroke: 2,
//                                         backgroundColor:
//                                             ColorCustom.blue.withOpacity(0.4),
//                                       ),
//                                       RadarTile(
//                                         values: avg2,
//                                         borderStroke: 2,
//                                         backgroundColor:
//                                             Colors.red.withOpacity(0.4),
//                                       ),
//                                     ],
//                                   ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.fiber_manual_record,
//                                   size: 15,
//                                   color: ColorCustom.blue,
//                                 ),
//                                 Text(
//                                   "ค่าเฉลี่ย",
//                                   style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.fiber_manual_record,
//                                   size: 15,
//                                   color: Colors.red,
//                                 ),
//                                 Text(
//                                   "คะแนน",
//                                   style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       dashboardRealtime != null
//                           ? Container(
//                               padding: EdgeInsets.all(10),
//                               margin: EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: ColorCustom.greyBG2),
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10.0),
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.near_me,
//                                         size: 40,
//                                         color: Colors.grey,
//                                       ),
//                                       Text(
//                                         'สถานะรถ',
//                                         style: TextStyle(
//                                           color: ColorCustom.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Stack(
//                                           alignment: Alignment.center,
//                                           children: [
//                                             SfCircularChart(
//                                                 // primaryXAxis: CategoryAxis(),
//                                                 // Chart title
//                                                 // title: ChartTitle(text: 'Half yearly sales analysis'),
//                                                 // Enable legend
//                                                 legend:
//                                                     Legend(isVisible: false),
//                                                 tooltipBehavior:
//                                                     TooltipBehavior(
//                                                         enable: true),
//                                                 series: <
//                                                     DoughnutSeries<ChartData,
//                                                         String>>[
//                                                   DoughnutSeries<ChartData, String>(
//                                                       radius: '80%',
//                                                       pointColorMapper:
//                                                           (ChartData data, _) =>
//                                                               data.color,
//                                                       innerRadius: '80%',
//                                                       explode: true,
//                                                       explodeOffset: '10%',
//                                                       dataSource: listCircle,
//                                                       xValueMapper: (ChartData data, _) =>
//                                                           ((data.value! * 100) / sumRealtime)
//                                                               .toStringAsFixed(
//                                                                   1) +
//                                                           "%",
//                                                       yValueMapper:
//                                                           (ChartData data, _) =>
//                                                               data.value,
//                                                       dataLabelMapper:
//                                                           (ChartData data, _) =>
//                                                               data.value
//                                                                   .toString(),
//                                                       dataLabelSettings:
//                                                           const DataLabelSettings(
//                                                               isVisible: true))
//                                                 ]),
//                                             Column(
//                                               children: [
//                                                 Text(
//                                                   'รถทั้งหมด',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 16,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   sumRealtime
//                                                           .toStringAsFixed(0) +
//                                                       ' คัน',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                         flex: 2,
//                                       ),
//                                       Container(
//                                         alignment: Alignment.centerLeft,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardRealtime!
//                                                           .ioColorDriving!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'วิ่ง',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardRealtime!
//                                                               .unitDriving!) +
//                                                       " คัน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardRealtime!
//                                                           .ioColorParking!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'ดับเครื่อง',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardRealtime!
//                                                               .unitParking!) +
//                                                       " คัน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardRealtime!
//                                                           .ioColorIdling!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'จอดไม่ดับเครื่อง',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardRealtime!
//                                                               .unitIdling!) +
//                                                       " คัน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardRealtime!
//                                                           .ioColorOverspeed!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'ความเร็วเกิน',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardRealtime!
//                                                               .unitOverspeed!) +
//                                                       " คัน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardRealtime!
//                                                           .ioColorOffline!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'ออฟไลน์',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardRealtime!
//                                                               .unitOffline!) +
//                                                       " คัน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Container(),
//                       dashboardDriver != null
//                           ? Container(
//                               padding: EdgeInsets.all(10),
//                               margin: EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: ColorCustom.greyBG2),
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10.0),
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.near_me,
//                                         size: 40,
//                                         color: Colors.grey,
//                                       ),
//                                       Text(
//                                         'คนขับรถของฉัน',
//                                         style: TextStyle(
//                                           color: ColorCustom.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Stack(
//                                           alignment: Alignment.center,
//                                           children: [
//                                             SfCircularChart(
//                                                 // primaryXAxis: CategoryAxis(),
//                                                 // Chart title
//                                                 // title: ChartTitle(text: 'Half yearly sales analysis'),
//                                                 // Enable legend
//                                                 legend:
//                                                     Legend(isVisible: false),
//                                                 tooltipBehavior:
//                                                     TooltipBehavior(
//                                                         enable: true),
//                                                 series: <
//                                                     DoughnutSeries<ChartData,
//                                                         String>>[
//                                                   DoughnutSeries<ChartData, String>(
//                                                       radius: '80%',
//                                                       pointColorMapper:
//                                                           (ChartData data, _) =>
//                                                               data.color,
//                                                       innerRadius: '80%',
//                                                       explode: true,
//                                                       explodeOffset: '10%',
//                                                       dataSource:
//                                                           listCircleDriver,
//                                                       xValueMapper: (ChartData data, _) =>
//                                                           ((data.value! * 100) /
//                                                                   sumDriver)
//                                                               .toStringAsFixed(
//                                                                   1) +
//                                                           "%",
//                                                       yValueMapper:
//                                                           (ChartData data, _) =>
//                                                               data.value,
//                                                       dataLabelMapper: (ChartData data,
//                                                               _) =>
//                                                           data.value.toString(),
//                                                       dataLabelSettings:
//                                                           const DataLabelSettings(
//                                                               isVisible: true))
//                                                 ]),
//                                             Column(
//                                               children: [
//                                                 Text(
//                                                   'รถทั้งหมด',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 16,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   sumDriver.toStringAsFixed(0) +
//                                                       ' คัน',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         flex: 2,
//                                       ),
//                                       Container(
//                                         alignment: Alignment.centerLeft,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardDriver!
//                                                           .ioColorSwipecard!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'รูดแล้ว',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardDriver!
//                                                               .unitSwipecard!) +
//                                                       " คน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardDriver!
//                                                           .ioColorNotSwipecard!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'ไม่ได้รูดบัตร',
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardDriver!
//                                                               .unitNotSwipecard!) +
//                                                       " คน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Icon(
//                                                   Icons.circle,
//                                                   size: 15,
//                                                   color: hexToColor(
//                                                       dashboardDriver!
//                                                           .ioColorValidate!),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   'ใบขับขี่ผิดประเภท',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30,
//                                                 ),
//                                                 Text(
//                                                   Utils.numberFormatInt(
//                                                           dashboardDriver!
//                                                               .unitValidate!) +
//                                                       " คน",
//                                                   style: TextStyle(
//                                                     color: ColorCustom.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Container(),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
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
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: indexTab == 1
//                       ? Container(
//                           margin: EdgeInsets.only(top: 20, left: 20),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: ColorCustom.greyBG2),
//                             color: ColorCustom.greyBG2,
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15.0),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Icon(
//                                 Icons.calendar_today,
//                                 size: 20,
//                                 color: Colors.grey,
//                               ),
//                               Expanded(
//                                 child: DateViewRangeCustom2View(
//                                   limit: 7,
//                                   controller: dateEditController,
//                                   returnDate: (value) {},
//                                   colors: Colors.grey,
//                                   disable: true,
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.keyboard_arrow_down,
//                                 color: Colors.grey,
//                                 size: 25,
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                             ],
//                           ),
//                         )
//                       : Container(
//                           margin: EdgeInsets.only(top: 20, left: 20),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: ColorCustom.greyBG2),
//                             color: ColorCustom.greyBG2,
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15.0),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Icon(
//                                 Icons.calendar_today,
//                                 size: 20,
//                                 color: Colors.black,
//                               ),
//                               Expanded(
//                                 child: DateViewRangeCustom2View(
//                                   limit: 7,
//                                   controller: dateEditController,
//                                   returnDate: (value) {
//                                     // start = DateFormat('yyyy-MM-dd')
//                                     //     .format(value.start);
//                                     // to = DateFormat('yyyy-MM-dd')
//                                     //     .format(value.end);
//
//                                     start = value.start;
//                                     to = value.end;
//                                     getData(context);
//                                   },
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.keyboard_arrow_down,
//                                 color: Colors.grey,
//                                 size: 25,
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (_) => DashboardFilter(
//                       //               data: (value) {
//                       //                 for (Vehicle v in value) {
//                       //                   listVid.add(v.info!.vid!);
//                       //                 }
//                       //                 getData(context);
//                       //               },
//                       //             )));.
//                       if (indexTab == 0) {
//                         showDia(context);
//                       }
//                     },
//                     child: Icon(
//                       Icons.filter_list,
//                       size: 30,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       primary: indexTab == 0 ? ColorCustom.blue : Colors.grey,
//                       shape: CircleBorder(),
//                       padding: EdgeInsets.all(5),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(child: _tabSection(context))
//           ],
//         ),
//       ),
//     );
//   }
// }
