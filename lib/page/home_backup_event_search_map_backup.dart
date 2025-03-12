// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animarker/flutter_map_marker_animation.dart';
// import 'package:flutter_xlider/flutter_xlider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:group_button/group_button.dart';
// import 'package:hino/model/history.dart';
// import 'package:hino/model/truck.dart';
// import 'package:hino/page/home_detail.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/utils/responsive.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:hino/widget/fancy_fab.dart';
//
// import 'dart:ui' as ui;
//
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//
// class HomeBackupEventSearchMapPage extends StatefulWidget {
//   const HomeBackupEventSearchMapPage({Key? key, required this.list})
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
//   final List<History> list;
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeBackupEventSearchMapPage> {
//   final markers = <MarkerId, Marker>{};
//
//   // final markersStart = <MarkerId, Marker>{};
//   // final markersStop = <MarkerId, Marker>{};
//   final controller = Completer<GoogleMapController>();
//
//   var kSantoDomingo;
//   var kMarkerId;
//
//   var kMarkerIdStart;
//   var kMarkerIdStop;
//
//   // Marker? markerStart;
//   // Marker? markerStop;
//   // List<Marker> listMarker = [];
//   List<LatLng> kLocations = [];
//   int duration = 300;
//   @override
//   void initState() {
//     _createMarkerImageFromAsset(context);
//     var kStartPosition = LatLng(widget.list[0].lat!, widget.list[0].lng!);
//     kSantoDomingo = CameraPosition(target: kStartPosition, zoom: 15);
//     kMarkerId = MarkerId('MarkerId1');
//     kMarkerIdStart = MarkerId('start');
//     kMarkerIdStop = MarkerId('stop');
//     kLocations = [kStartPosition];
//     for (History h in widget.list) {
//       kLocations.add(LatLng(h.lat!, h.lng!));
//     }
//
//     _add();
//      var stream = Stream.periodic(
//             Duration(milliseconds: duration), (count) => kLocations[count])
//         .take(kLocations.length);
//     stream.forEach((value){
//       if(!isPlay){
//         sleep(Duration(seconds:1000));
//       }else{
//         newLocationUpdate(value);
//       }
//
//     });
//
//
//     markers[kMarkerIdStart] = Marker(
//       markerId: kMarkerIdStart,
//       position: kStartPosition,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
//     );
//     markers[kMarkerIdStop] = Marker(
//       markerId: kMarkerIdStop,
//       position: kLocations[kLocations.length - 1],
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
//     );
//
//     super.initState();
//   }
//
//   BitmapDescriptor? _markerIcon;
//
//   Future _createMarkerImageFromAsset(BuildContext context) async {
//     if (_markerIcon == null) {
//       ImageConfiguration configuration = ImageConfiguration();
//       BitmapDescriptor bmpd = await BitmapDescriptor.fromAssetImage(
//           configuration, 'assets/images/truck_pin_green.png');
//       setState(() {
//         _markerIcon = bmpd;
//       });
//     }
//   }
//
//   Map<PolylineId, Polyline> _mapPolylines = {};
//   int _polylineIdCounter = 1;
//
//   void _add() {
//     final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
//     _polylineIdCounter++;
//     final PolylineId polylineId = PolylineId(polylineIdVal);
//
//     final Polyline polyline = Polyline(
//       polylineId: polylineId,
//       consumeTapEvents: true,
//       color: ColorCustom.blue,
//       width: 5,
//       points: kLocations,
//     );
//
//     setState(() {
//       _mapPolylines[polylineId] = polyline;
//     });
//   }
//
//   LatLngBounds boundsFromLatLngList(List<LatLng> list) {
//     assert(list.isNotEmpty);
//     double? x0, x1 = 0, y0 = 0, y1 = 0;
//     for (LatLng latLng in list) {
//       if (x0 == null) {
//         x0 = x1 = latLng.latitude;
//         y0 = y1 = latLng.longitude;
//       } else {
//         if (latLng.latitude > x1!) x1 = latLng.latitude;
//         if (latLng.latitude < x0) x0 = latLng.latitude;
//         if (latLng.longitude > y1!) y1 = latLng.longitude;
//         if (latLng.longitude < y0!) y0 = latLng.longitude;
//       }
//     }
//     return LatLngBounds(
//         northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
//   }
//
//   bool isPlay = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Animarker(
//
//                 curve: Curves.ease,
//                 shouldAnimateCamera: false,
//
//                 mapId: controller.future.then<int>((value) => value.mapId),
//                 //Grab Google Map Id
//                 markers: markers.values.toSet(),
//                 // markers: Set<Marker>.of(markers.),
//
//                 child: GoogleMap(
//                   zoomControlsEnabled: false,
//                   mapType: MapType.normal,
//                   initialCameraPosition: kSantoDomingo,
//                   polylines: Set<Polyline>.of(_mapPolylines.values),
//                   // onMapCreated: (gController) => controller.complete(
//                   //     gController),
//                   onMapCreated: (gController) {
//                     controller.complete(gController);
//                     setState(() {
//                       gController.animateCamera(CameraUpdate.newLatLngBounds(
//                           boundsFromLatLngList(kLocations), 50));
//                     });
//                   },
//                   // Complete the future GoogleMapController
//                 ),
//               ),
//             ),
//             // Container(
//             //   padding: EdgeInsets.all(20),
//             //   child: Row(
//             //     crossAxisAlignment: CrossAxisAlignment.center,
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       ElevatedButton(
//             //         onPressed: () {
//             //
//             //         },
//             //         child: Icon(Icons.fast_rewind),
//             //         style: ElevatedButton.styleFrom(
//             //           shape: CircleBorder(),
//             //           padding: EdgeInsets.all(5),
//             //         ),
//             //       ),
//             //       ElevatedButton(
//             //         onPressed: () {
//             //
//             //           if(isPlay){
//             //             isPlay = false;
//             //             duration = 0;
//             //           }else{
//             //             isPlay = true;
//             //             duration = 300;
//             //           }
//             //           setState(() {
//             //
//             //           });
//             //         },
//             //         child: Icon(
//             //           isPlay ? Icons.stop : Icons.play_arrow,
//             //           size: 40,
//             //         ),
//             //         style: ElevatedButton.styleFrom(
//             //           shape: CircleBorder(),
//             //           padding: EdgeInsets.all(5),
//             //         ),
//             //       ),
//             //       ElevatedButton(
//             //         onPressed: () {
//             //
//             //         },
//             //         child: Icon(Icons.fast_forward),
//             //         style: ElevatedButton.styleFrom(
//             //           shape: CircleBorder(),
//             //           padding: EdgeInsets.all(5),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void newLocationUpdate(LatLng latLng) {
//     var marker = Marker(
//       markerId: kMarkerId,
//       position: latLng,
//       // ripple: true,
//       anchor: const Offset(0.5, 0.5),
//       icon: _markerIcon!,
//     );
//     setState(() => markers[kMarkerId] = marker);
//   }
// }
