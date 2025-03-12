// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hino/model/driver_detail.dart';
// import 'package:hino/model/eco.dart';
// import 'package:hino/model/safety.dart';
// import 'package:hino/model/truck.dart';
// import 'package:hino/model/vehicle.dart';
// import 'package:hino/page/home_car_filter.dart';
// import 'package:hino/page/home_detail.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/utils/responsive.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:hino/widget/fancy_fab.dart';
//
// import 'dart:ui' as ui;
//
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:radar_chart/radar_chart.dart';
//
// import 'home_car_sort.dart';
// import 'home_driver_detail.dart';
//
// class HomeCarSummaryPage extends StatefulWidget {
//   const HomeCarSummaryPage({Key? key, required this.vehicle}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//   final Vehicle vehicle;
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeCarSummaryPage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   List<String> features = [];
//   List<double> avg = [];
//   List<double> point = [];
//
//   List<String> features2 = [];
//   List<double> avg2 = [];
//   List<double> point2 = [];
//   initChart(DriverDetail driverDetail) {
//     // for (Eco eco in driverDetail.eco) {
//     //   features.add(eco.arg!);
//     //   avg.add(eco.avg!/5);
//     //   point.add(eco.point!/5);
//     //
//     //
//     // }
//
//     for (Safety safe in driverDetail.safety) {
//       features2.add(safe.arg!);
//       avg2.add(safe.avg!/5);
//       point2.add(safe.point!/5);
//
//
//     }
//   }
//
//   TabController? tabController;
//
//   Widget _tabSection(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(10),
//             color: Colors.white,
//             child: TabBar(
//               controller: tabController,
//               tabs: [
//                 Tab(text: "ภาพรวม"),
//                 Tab(text: "ภาพรวมข้อมูล"),
//               ],
//               indicatorColor: ColorCustom.primaryAssentColor,
//               labelColor: Colors.black,
//               unselectedLabelColor: Colors.grey,
//               labelStyle: GoogleFonts.kanit(),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(10),
//             //Add this to give height
//             height: MediaQuery.of(context).size.height,
//             child: TabBarView(
//               controller: tabController,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       margin: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: ColorCustom.greyBG2),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               // Icon(
//                               //   Icons.spa,
//                               //   size: 50,
//                               //   color: Colors.grey,
//                               // ),
//                               SvgPicture.asset(
//                                 "assets/images/Fix Icon Hino29.svg",
//                                 width: 50,
//                                 height: 50,
//                                 color: Colors.grey,
//                               ),
//                               Text(
//                                 'การขับขี่แบบประหยัด',
//                                 style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           // Container(
//                           //   width: 200,
//                           //   height: 200,
//                           //   child: RadarChart.light(
//                           //     ticks: ticks,
//                           //     features: features,
//                           //     data: data,
//                           //     reverseAxis: true,
//                           //     useSides: true,
//                           //   ),
//                           // ),
//                           avg.isEmpty?Container():RadarChart(
//                             length: avg.length,
//                             radius: 100,
//                             initialAngle: 0,
//                             backgroundColor: Colors.white,
//                             borderStroke: 2,
//                             borderColor: Colors.grey.shade300,
//
//                             radialStroke: 1,
//                             radialColor: Colors.grey.shade300,
//                             vertices: [
//
//                               for (int i = 0; i < features.length; i++)
//                                 RadarVertex(
//                                   radius: 15,
//                                   textOffset: Offset(0, 0),
//                                   text:   Text(features[i],
//                                     style: TextStyle(
//                                       color: ColorCustom.black,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                             radars: [
//                               RadarTile(
//
//                                 radialColor: Colors.red,
//                                 values: point,
//                                 borderStroke: 2,
//                                 borderColor: Colors.green,
//                                 backgroundColor: Colors.green.withOpacity(0.4),
//                               ),
//                               RadarTile(
//                                 radialColor: Colors.red,
//                                 values: avg,
//                                 borderStroke: 2,
//                                 borderColor: ColorCustom.blue,
//                                 backgroundColor: ColorCustom.blue.withOpacity(0.4),
//                               ),
//
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.fiber_manual_record,
//                                 size: 15,
//                                 color: Colors.green,
//                               ),
//                               Text("มาตรฐาน",
//                                 style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontSize: 12,
//                                 ),
//                               ),
//
//                               Icon(
//                                 Icons.fiber_manual_record,
//                                 size: 15,
//                                 color: ColorCustom.blue,
//                               ),
//                               Text("คะแนน",
//                                 style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // Image.asset("assets/images/driver_graph.png"),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       margin: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: ColorCustom.greyBG2),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               SvgPicture.asset(
//                                 "assets/images/Fix Icon Hino30.svg",
//                                 width: 50,
//                                 height: 50,
//                                 color: Colors.grey,
//                               ),
//                               Text(
//                                 'การขับขี่แบบปลอดภัย',
//                                 style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           avg2.isEmpty?Container():RadarChart(
//                             length: avg2.length,
//                             radius: 100,
//                             initialAngle: 0,
//                             backgroundColor: Colors.white,
//                             borderStroke: 2,
//                             borderColor: Colors.grey.shade300,
//
//                             radialStroke: 1,
//                             radialColor: Colors.grey.shade300,
//                             vertices: [
//
//                               for (int i = 0; i < features2.length; i++)
//                                 RadarVertex(
//                                   radius: 15,
//                                   textOffset: Offset(0, 0),
//                                   text:   Text(features2[i],
//                                     style: TextStyle(
//                                       color: ColorCustom.black,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                             radars: [
//                               RadarTile(
//
//                                 radialColor: Colors.red,
//                                 values: point2,
//                                 borderStroke: 2,
//                                 borderColor: ColorCustom.blue,
//                                 backgroundColor: ColorCustom.blue.withOpacity(0.4),
//                               ),
//                               RadarTile(
//                                 radialColor: Colors.red,
//                                 values: avg2,
//                                 borderStroke: 2,
//                                 borderColor: Colors.red,
//                                 backgroundColor: Colors.red.withOpacity(0.4),
//                               ),
//
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.fiber_manual_record,
//                                 size: 15,
//                                 color: ColorCustom.blue,
//                               ),
//                               Text("มาตรฐาน",
//                                 style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontSize: 12,
//                                 ),
//                               ),
//
//                               Icon(
//                                 Icons.fiber_manual_record,
//                                 size: 15,
//                                 color: Colors.red,
//                               ),
//                               Text("คะแนน",
//                                 style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   child: ListView.builder(
//                     padding: EdgeInsets.all(10),
//                     shrinkWrap: false,
//                     itemCount: 10,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () {
//                           // Navigator.push(
//                           //     context, MaterialPageRoute(builder: (_) => MotorbikePage()));
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(bottom: 10),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: ColorCustom.greyBG2),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(10.0),
//                             ),
//                           ),
//                           padding: EdgeInsets.only(
//                               top: 10, bottom: 10, left: 10, right: 10),
//                           child: Row(
//                             children: [
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               index == 2
//                                   ? Image.asset(
//                                       "assets/images/maps_icon.png",
//                                       height: 60,
//                                       width: 60,
//                                     )
//                                   : Image.asset(
//                                       "assets/images/car_icon2.png",
//                                       height: 60,
//                                       width: 60,
//                                     ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '80-9999',
//                                       style: TextStyle(
//                                           color: ColorCustom.black,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text('กรุงเทพมหานคร',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 12,
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     '30',
//                                     style: TextStyle(
//                                         color: ColorCustom.black,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text('กม/ชม',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12,
//                                       )),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
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
//           child: SingleChildScrollView(
//         child: Column(
//           children: [
//             BackIOS(),
//
//             _tabSection(context)
//           ],
//         ),
//       )),
//     );
//   }
// }
