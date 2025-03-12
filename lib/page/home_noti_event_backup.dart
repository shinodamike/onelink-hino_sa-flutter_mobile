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
// import 'package:hino/api/api.dart';
// import 'package:hino/model/noti.dart';
// import 'package:hino/model/noti_group.dart';
// import 'package:hino/model/truck.dart';
// import 'package:hino/model/vehicle.dart';
// import 'package:hino/page/home_backup_event.dart';
// import 'package:hino/page/home_car_filter.dart';
// import 'package:hino/page/home_detail.dart';
// import 'package:hino/page/home_driver_detail.dart';
// import 'package:hino/page/home_noti_map.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/utils/responsive.dart';
// import 'package:hino/utils/utils.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:hino/widget/fancy_fab.dart';
//
// import 'dart:ui' as ui;
//
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//
// import 'home_backup_playback.dart';
// import 'home_car_sort.dart';
// import 'home_realtime.dart';
//
// class HomeNotiEventPage extends StatefulWidget {
//    HomeNotiEventPage({Key? key,  this.listData,this.name,this.license}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//    List<Noti>? listData = [];
//    String? name ;
//    String? license ;
//
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeNotiEventPage> {
//   @override
//   void initState() {
//     if(widget.listData!=null){
//
//       listDriver.addAll(widget.listData!);
//     }else{
//       getData(context);
//     }
//     super.initState();
//   }
//
//   List<Noti> listData = [];
//   getData(BuildContext context) {
//     var param = jsonEncode(<dynamic, dynamic>{
//       "user_id": Api.profile?.userId,
//       "per_page": 100,
//       "event_list": [1001, 1004, 1007, 10000, 10001],
//     });
//     Api.post(context, Api.notify, param).then((value) => {
//       if (value != null)
//         {
//           listData = List.from(value['result'])
//               .map((a) => Noti.fromJson(a))
//               .toList(),
//           groupDriver(),
//           refresh(),
//         }
//       else
//         {}
//     });
//   }
//
//   refresh(){
//     setState(() {
//
//     });
//   }
//
//   List<Noti> listDriver = [];
//
//   groupDriver() {
//     if(widget.name!=null){
//
//       for(Noti n in listData){
//         // print(widget.name!+"  "+n.driver_name!);
//         if(widget.name!.toLowerCase()==n.driver_name!.toLowerCase()){
//           listDriver.add(n);
//         }
//       }
//     }else if(widget.license!=null){
//
//       for(Noti n in listData){
//         // print(widget.name!+"  "+n.driver_name!);
//         if(widget.license!.toLowerCase()==n.license!.toLowerCase()){
//           listDriver.add(n);
//         }
//       }
//     }
//
//
//
//
//   }
//
//   showSort(BuildContext context) {
//     showMaterialModalBottomSheet(
//       expand: false,
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => HomeCarSortPage(
//         select: (i){
//
//         },
//       ),
//     );
//   }
//
//   showDetail() {
//     showBarModalBottomSheet(
//       expand: true,
//       context: context,
//       backgroundColor: Colors.transparent,
//       // builder: (context) => HomeDriverDetailPage(),
//       builder: (context) => Container(),
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
//             BackIOS(),
//             Container(
//               margin: EdgeInsets.only(left: 20, right: 20, top: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'วันนี้',
//                       style: TextStyle(
//                         color: ColorCustom.black,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     listDriver.length.toString()+' ครั้ง',
//                     style: TextStyle(
//                       color: ColorCustom.blue,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.all(10),
//                 shrinkWrap: false,
//                 itemCount: listDriver.length,
//                 itemBuilder: (BuildContext context, int index) {
//
//                   Noti no = listDriver[index];
//                   // Vehicle v = widget.listVehicle[index];
//
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context, MaterialPageRoute(builder: (_) => HomeNotiMapPage(noti: no)));
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(bottom: 10),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: ColorCustom.greyBG2),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       padding: EdgeInsets.only(
//                           top: 10, bottom: 10, left: 10, right: 10),
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(no.license!,
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     // Text(v.info!.licenseprov!,
//                                     //   style: TextStyle(
//                                     //     color: Colors.grey,
//                                     //     fontSize: 14,
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                                 Text(no.driver_name!,
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Text(no.location!,
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(Utils.convertDateToBase(no.gpsdate!),
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               Utils.eventIcon(no),
//                               // Container(
//                               //   width: 50,
//                               //   height: 50,
//                               //   decoration: BoxDecoration(
//                               //     color: Colors.red.shade100,
//                               //     borderRadius: BorderRadius.circular(100),
//                               //   ),
//                               //   alignment: Alignment.center,
//                               //   child: Column(
//                               //     mainAxisAlignment: MainAxisAlignment.center,
//                               //     crossAxisAlignment: CrossAxisAlignment.center,
//                               //     children: [
//                               //       Text(no.speed.toString(),
//                               //         style: TextStyle(
//                               //             color: Colors.red,
//                               //             fontSize: 16,
//                               //             fontWeight: FontWeight.bold),
//                               //       ),
//                               //       Text(
//                               //         'กม/ชม',
//                               //         style: TextStyle(
//                               //             color: Colors.red,
//                               //             fontSize: 8,
//                               //             fontWeight: FontWeight.bold),
//                               //       ),
//                               //     ],
//                               //   ),
//                               // ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
