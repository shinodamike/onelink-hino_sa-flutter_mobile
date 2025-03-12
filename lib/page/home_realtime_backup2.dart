// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hino/api/api.dart';
// import 'package:hino/model/factory.dart';
// import 'package:hino/model/factory_latlng.dart';
// import 'package:hino/model/member.dart';
// import 'package:hino/model/place.dart';
// import 'package:hino/model/truck.dart';
// import 'package:hino/model/vehicle.dart';
// import 'package:hino/page/home_car.dart';
// import 'package:hino/page/home_car_summary.dart';
// import 'package:hino/page/home_detail.dart';
// import 'package:hino/page/home_news.dart';
// import 'package:hino/page/info.dart';
// import 'package:hino/provider/page_provider.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/utils/responsive.dart';
// import 'package:hino/utils/utils.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:hino/widget/fancy_fab.dart';
//
// import 'dart:ui' as ui;
//
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:provider/src/provider.dart';
//
// import 'home_noti.dart';
//
// List<Place> listPlace = [];
// List<Vehicle> listVehicle = [];
// List<Factory> listFactory = [];
// Vehicle? selectVehicle;
//
// bool isAdvertise = true;
//
// class HomeRealtimePage extends StatefulWidget {
//   const HomeRealtimePage({Key? key}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeRealtimePage> {
//   Uint8List? markerIcon;
//   late ClusterManager _manager;
//   ValueNotifier<bool> isDialOpen = ValueNotifier(false);
//   Timer? timer;
//
//   @override
//   void initState() {
//     _createMarkerImageFromAsset(context);
//     // createCustomMarkerBitmap("test");
//     // getMarkerIcon("assets/images/truck_pin_green.png", Size(120, 120)).then((value) => {
//     //   _markerIcon = value
//     // });
//     // getMarkerIcon("assets/images/truck_pin_green.png", Size(120, 120)).then((value) => {
//     //   _markerIcon = value
//     // });
//     // getMarkerIcon("assets/images/truck_pin_green.png", Size(120, 120)).then((value) => {
//     //   _markerIcon = value
//     // });
//
//     _manager = _initClusterManager();
//     if (listVehicle.isEmpty) {
//       getData(context);
//       getDataFactory(context);
//     } else {
//       // _manager = _initClusterManager();
//       // isLoaded = true;
//       // refresh();
//     }
//     timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
//       listPlace.clear();
//       getData(context);
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
//   ClusterManager _initClusterManager() {
//     return ClusterManager<Place>(listPlace, _updateMarkers,
//         markerBuilder: _markerBuilder, stopClusteringZoom: 14.0);
//   }
//
//   void _updateMarkers(Set<Marker> markers) {
//     print('Updated ${markers.length} markers');
//     this.markers = markers;
//     // this.markers.addAll(_markersTruck);
//     print(this.markers.length.toString());
//     refresh();
//   }
//
//   markerVehicleClick(Vehicle v){
//     vehicleClick = v;
//     kLocations.clear();
//     setRadius(
//         LatLng(vehicleClick!.gps!.lat!, vehicleClick!.gps!.lng!),
//         vehicleClick!.info!.vid!.toString(),
//         80);
//     mapController!.animateCamera(CameraUpdate.newLatLngZoom(
//         LatLng(vehicleClick!.gps!.lat!, vehicleClick!.gps!.lng!),
//         16));
//     setState(() {
//       isShowDetail = true;
//       isShowDetailFactory = false;
//       isShowDetailFactoryFull = false;
//     });
//   }
//
//   markerFactoryClick(Factory fac){
//     factoryClick = fac;
//     setRadius(
//         LatLng(factoryClick!.lat, factoryClick!.lng),
//         factoryClick!.id.toString(),
//         factoryClick!.radius!.toDouble());
//     mapController!.animateCamera(CameraUpdate.newLatLngZoom(
//         LatLng(factoryClick!.lat, factoryClick!.lng), 16));
//     setState(() {
//       isShowDetail = false;
//       isShowDetailFactory = true;
//       isShowDetailFactoryFull = false;
//     });
//   }
//
//   Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
//       (cluster) async {
//         if (cluster.items.length == 1) {
//           Factory? fac;
//           Vehicle? v;
//           cluster.items.forEach((p) => {
//                 v = p.vehicle,
//                 fac = p.factory,
//               });
//           if (v != null) {
//             return Marker(
//               markerId: MarkerId(cluster.getId()),
//               position: cluster.location,
//               onTap: () {
//                 markerVehicleClick(v!);
//                 // vehicleClick = v;
//                 // kLocations.clear();
//                 // setRadius(
//                 //     LatLng(vehicleClick!.gps!.lat!, vehicleClick!.gps!.lng!),
//                 //     vehicleClick!.info!.vid!.toString(),
//                 //     80);
//                 // mapController!.animateCamera(CameraUpdate.newLatLngZoom(
//                 //     LatLng(vehicleClick!.gps!.lat!, vehicleClick!.gps!.lng!),
//                 //     16));
//                 // setState(() {
//                 //   isShowDetail = true;
//                 //   isShowDetailFactory = false;
//                 //   isShowDetailFactoryFull = false;
//                 // });
//               },
//               rotation: v!.gps!.course!,
//               anchor: const Offset(0.5, 0.5),
//               // icon: getMapIcon(v!.gps!.io_name!)!,
//               icon:
//                   await getMarkerIcon(v!.gps!.io_name!, v!.info!.licenseplate!),
//             );
//           }
//           return Marker(
//             markerId: MarkerId(cluster.getId()),
//             position: cluster.location,
//             anchor: const Offset(0.5, 0.5),
//             onTap: () {
//               markerFactoryClick(fac!);
//               // print('---- $cluster');
//               // factoryClick = fac;
//               // setRadius(
//               //     LatLng(factoryClick!.lat, factoryClick!.lng),
//               //     factoryClick!.id.toString(),
//               //     factoryClick!.radius!.toDouble());
//               // mapController!.animateCamera(CameraUpdate.newLatLngZoom(
//               //     LatLng(factoryClick!.lat, factoryClick!.lng), 16));
//               // setState(() {
//               //   isShowDetail = false;
//               //   isShowDetailFactory = true;
//               //   isShowDetailFactoryFull = false;
//               // });
//             },
//             icon: await _getMarkerBitmap3(
//                 cluster, cluster.isMultiple ? 125 : 75,
//                 text: cluster.isMultiple ? cluster.count.toString() : null),
//           );
//         } else {
//           return Marker(
//             markerId: MarkerId(cluster.getId()),
//             position: cluster.location,
//             anchor: const Offset(0.5, 0.5),
//             onTap: () {
//               print('---- $cluster');
//               cluster.items.forEach((p) => {
//                     if (cluster.items.length == 1)
//                       {
//                         if (p.factory != null)
//                           {
//                             markerFactoryClick(p.factory!),
//                             // factoryClick = p.factory,
//                             // setRadius(
//                             //     LatLng(factoryClick!.lat, factoryClick!.lng),
//                             //     factoryClick!.id.toString(),
//                             //     factoryClick!.radius!.toDouble()),
//                             // mapController!.animateCamera(
//                             //     CameraUpdate.newLatLngZoom(
//                             //         LatLng(
//                             //             factoryClick!.lat, factoryClick!.lng),
//                             //         16)),
//                             // setState(() {
//                             //   isShowDetail = false;
//                             //   isShowDetailFactory = true;
//                             //   isShowDetailFactoryFull = false;
//                             // })
//                           }
//                         else
//                           {
//                           markerVehicleClick(p.vehicle!),
//                             // vehicleClick = p.vehicle,
//                             // kLocations.clear(),
//                             // setRadius(
//                             //     LatLng(vehicleClick!.gps!.lat!,
//                             //         vehicleClick!.gps!.lng!),
//                             //     vehicleClick!.info!.vid!.toString(),
//                             //     80),
//                             // mapController!.animateCamera(
//                             //     CameraUpdate.newLatLngZoom(
//                             //         LatLng(vehicleClick!.gps!.lat!,
//                             //             vehicleClick!.gps!.lng!),
//                             //         16)),
//                             // setState(() {
//                             //   isShowDetail = true;
//                             //   isShowDetailFactory = false;
//                             //   isShowDetailFactoryFull = false;
//                             // }),
//                           }
//                       }
//                   });
//             },
//             icon: await _getMarkerBitmap3(
//                 cluster, cluster.isMultiple ? 125 : 75,
//                 text: cluster.isMultiple ? cluster.count.toString() : null),
//           );
//         }
//       };
//
//   bool isLicense = false;
//
//   Future<BitmapDescriptor> getMarkerIcon(String status, String license) async {
//     String imagePath = "assets/images/truck_pin_green.png";
//     switch (status.toLowerCase()) {
//       case "driving":
//         imagePath = "assets/images/truck_pin_green.png";
//         break;
//       case "ign.off":
//         imagePath = "assets/images/truck_pin_red.png";
//         break;
//       case "idling":
//         imagePath = "assets/images/truck_pin_yellow.png";
//         break;
//       case "offline":
//         imagePath = "assets/images/truck_pin_red.png";
//         break;
//       case "over speed":
//         imagePath = "assets/images/truck_pin_green.png";
//         break;
//     }
//     if (!isLicense) {
//       ImageConfiguration configuration = ImageConfiguration();
//       return await BitmapDescriptor.fromAssetImage(configuration, imagePath);
//     }
//
//     Size size = Size(120, 120);
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//
//     final Radius radius = Radius.circular(size.width / 2);
//
//     final Paint tagPaint = Paint()..color = ColorCustom.blue;
//     final double tagWidth = 40.0;
//
//     final Paint shadowPaint = Paint()..color = ColorCustom.blue.withAlpha(100);
//     final double shadowWidth = 15.0;
//
//     final Paint borderPaint = Paint()..color = Colors.white;
//     final double borderWidth = 3.0;
//
//     final double imageOffset = shadowWidth + borderWidth;
//
//     // Add shadow circle
//     canvas.drawRRect(
//         RRect.fromRectAndCorners(
//           Rect.fromLTWH(0.0, 0.0, size.width, size.height),
//           topLeft: radius,
//           topRight: radius,
//           bottomLeft: radius,
//           bottomRight: radius,
//         ),
//         shadowPaint);
//
//     // Add border circle
//     canvas.drawRRect(
//         RRect.fromRectAndCorners(
//           Rect.fromLTWH(shadowWidth, shadowWidth,
//               size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
//           topLeft: radius,
//           topRight: radius,
//           bottomLeft: radius,
//           bottomRight: radius,
//         ),
//         borderPaint);
//
//     // Add tag circle
//     canvas.drawRRect(
//         RRect.fromRectAndCorners(
//           Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
//           topLeft: radius,
//           topRight: radius,
//           bottomLeft: radius,
//           bottomRight: radius,
//         ),
//         tagPaint);
//
//     // Add tag text
//     TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
//     textPainter.text = TextSpan(
//       text: license,
//       style: TextStyle(fontSize: 20.0, color: Colors.white),
//     );
//
//     textPainter.layout();
//     textPainter.paint(
//         canvas,
//         Offset(size.width - tagWidth / 2 - textPainter.width / 2,
//             tagWidth / 2 - textPainter.height / 2));
//
//     // Oval for the image
//     Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
//         size.width - (imageOffset * 2), size.height - (imageOffset * 2));
//
//     // Add path for oval image
//     canvas.clipPath(Path()..addOval(oval));
//
//     // Add image
//
//     ui.Image image = await getImageFromPath(
//         imagePath); // Alternatively use your own method to get the image
//     print("GET MARKER ICON CUSTOMISE CALLED" + image.height.toString());
//     paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);
//
//     // Convert canvas to image
//     final ui.Image markerAsImage = await pictureRecorder
//         .endRecording()
//         .toImage(size.width.toInt(), size.height.toInt());
//
//     // Convert image to bytes
//     final ByteData? byteData =
//         await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
//     final Uint8List uint8List = byteData!.buffer.asUint8List();
//     // iconTest = BitmapDescriptor.fromBytes(uint8List);
//
//     return BitmapDescriptor.fromBytes(uint8List);
//   }
//
//   Future<ui.Image> getImageFromPath(String imagePath) async {
//     //String fullPathOfImage = await getFileData(imagePath);
//
//     //File imageFile = File(fullPathOfImage);
//     ByteData bytes = await rootBundle.load(imagePath);
//     Uint8List imageBytes = bytes.buffer.asUint8List();
//     //Uint8List imageBytes = imageFile.readAsBytesSync();
//
//     final Completer<ui.Image> completer = new Completer();
//
//     ui.decodeImageFromList(imageBytes, (ui.Image img) {
//       return completer.complete(img);
//     });
//     //print("COMPLETERR DONE Full path of image is"+imagePath);
//     return completer.future;
//   }
//
//   BitmapDescriptor? iconTest;
//
//   Future<BitmapDescriptor> _getMarkerBitmap3(Cluster<Place> cluster, int size,
//       {String? text}) async {
//     // if (kIsWeb) size = (size / 2).floor();
//
//     final PictureRecorder pictureRecorder = PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     Paint paint1 = Paint()..color = ColorCustom.blue;
//     final Paint paint2 = Paint()..color = Colors.white;
//
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
//
//     if (text != null) {
//       TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
//       painter.text = TextSpan(
//         text: text,
//         style: TextStyle(
//             fontSize: size / 3,
//             color: Colors.white,
//             fontWeight: FontWeight.normal),
//       );
//       painter.layout();
//       painter.paint(
//         canvas,
//         Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
//       );
//       final img = await pictureRecorder.endRecording().toImage(size, size);
//       final data =
//           await img.toByteData(format: ImageByteFormat.png) as ByteData;
//
//       return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
//     } else {
//       var a;
//       cluster.items.forEach((p) => {
//             if (p.factory != null)
//               {a = _markerIconFactory}
//             else
//               {a = getMapIcon(p.vehicle!.gps!.io_name!)}
//           });
//       return a;
//     }
//   }
//
//   Set<Marker> markers = Set();
//
//   getData(BuildContext context) {
//     Api.get(context, Api.realtime).then((value) => {
//           if (value != null)
//             {
//               listVehicle = List.from(value['vehicles'])
//                   .map((a) => Vehicle.fromJson(a))
//                   .toList(),
//               updatePinRefresh(),
//               // for (Vehicle v in listVehicle)
//               //   {
//               //     listPlace.add(new Place(
//               //         latLng: LatLng(v.gps!.lat!, v.gps!.lng!), vehicle: v)),
//               //   },
//               // refresh()
//             }
//           else
//             {}
//         });
//   }
//
//   // bool isLoaded = false;
//
//   getDataFactory(BuildContext context) {
//     double lat = 0;
//     double lng = 0;
//     var a;
//     List<FactoryLatLng> list = [];
//     Api.get(context, Api.factory).then((value) => {
//           if (value != null)
//             {
//               listFactory = List.from(value['data'])
//                   .map((a) => Factory.fromJson(a))
//                   .toList(),
//               // if (isPinFactory)
//               //   {
//               //     for (Factory v in listFactory)
//               //       {
//               //         listPlace.add(
//               //             new Place(latLng: LatLng(v.lat, v.lng), factory: v)),
//               //       },
//               //   },
//               updatePinRefresh(),
//               refresh(),
//             }
//           else
//             {}
//         });
//   }
//
//   updatePinRefresh() {
//     for (Vehicle v in listVehicle) {
//       if (isShowDetail &&
//           vehicleClick != null &&
//           vehicleClick!.info!.vid == v.info!.vid!) {
//         vehicleClick = v;
//         setRadius(LatLng(vehicleClick!.gps!.lat!, vehicleClick!.gps!.lng!),
//             vehicleClick!.info!.vid!.toString(), 80);
//         mapController!.animateCamera(CameraUpdate.newLatLngZoom(
//             LatLng(vehicleClick!.gps!.lat!, vehicleClick!.gps!.lng!), 16));
//         kLocations.add(LatLng(vehicleClick!.gps!.lat!, vehicleClick!.gps!.lng!));
//         setLine();
//       }
//       listPlace
//           .add(new Place(latLng: LatLng(v.gps!.lat!, v.gps!.lng!), vehicle: v));
//     }
//     if (isPinFactory) {
//       for (Factory v in listFactory) {
//         listPlace.add(new Place(latLng: LatLng(v.lat, v.lng), factory: v));
//       }
//     }
//
//     markers.clear();
//     _manager.setItems(listPlace);
//     refresh();
//   }
//
//   Future<Timer> eneblePlate() async {
//     return new Timer(Duration(seconds: 1), onDoneControl2);
//   }
//
//   onDoneControl2() {
//     _manager = _initClusterManager();
//     // isLoaded = true;
//     refresh();
//   }
//
//   Set<Circle>? circles;
//   Set<Circle> circlesDef = Set.from([
//     Circle(
//       circleId: CircleId(""),
//       center: LatLng(0, 0),
//       radius: 0,
//     )
//   ]);
//
//   setRadius(LatLng latLng, String id, double radiusA) {
//     circles = Set.from([
//       Circle(
//         fillColor: ColorCustom.blue.withOpacity(0.2),
//         strokeWidth: 0,
//         circleId: CircleId(id),
//         center: latLng,
//         radius: radiusA,
//       )
//     ]);
//   }
//
//   refresh() {
//     setState(() {});
//   }
//
//   Completer<GoogleMapController> _controller = Completer();
//   GoogleMapController? mapController;
//   LocationData? currentLocation;
//
//   Future<LocationData?> getCurrentLocation() async {
//     Location location = Location();
//     try {
//       return await location.getLocation();
//     } on PlatformException catch (e) {
//       if (e.code == 'PERMISSION_DENIED') {
//         // Permission denied
//       }
//       return null;
//     }
//   }
//
//   List<LatLng> kLocations = [];
//   Map<PolylineId, Polyline> _mapPolylines = {};
//   int _polylineIdCounter = 1;
//
//   void setLine() {
//     final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
//     _polylineIdCounter++;
//     final PolylineId polylineId = PolylineId(polylineIdVal);
//
//     final Polyline polyline = Polyline(
//       polylineId: polylineId,
//       consumeTapEvents: true,
//       color: Colors.green,
//       width: 5,
//       points: kLocations,
//     );
//
//     setState(() {
//       _mapPolylines[polylineId] = polyline;
//     });
//   }
//
//   Future _goToMe() async {
//     final GoogleMapController controller = await _controller.future;
//     currentLocation = (await getCurrentLocation())!;
//     if (currentLocation != null) {
//       controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//         zoom: 16,
//       )));
//     }
//   }
//
//   BitmapDescriptor? _markerIcon;
//   BitmapDescriptor? _markerIcon2;
//   BitmapDescriptor? _markerIcon3;
//
//   Future _createMarkerImageFromAsset(BuildContext context) async {
//     if (_markerIcon == null) {
//       ImageConfiguration configuration = ImageConfiguration();
//       BitmapDescriptor bmpd = await BitmapDescriptor.fromAssetImage(
//           configuration, 'assets/images/truck_pin_green.png');
//       BitmapDescriptor bmpd2 = await BitmapDescriptor.fromAssetImage(
//           configuration, 'assets/images/truck_pin_red.png');
//       BitmapDescriptor bmpd3 = await BitmapDescriptor.fromAssetImage(
//           configuration, 'assets/images/truck_pin_yellow.png');
//       BitmapDescriptor bmpd4 = await BitmapDescriptor.fromAssetImage(
//           configuration, 'assets/images/factory_pin.png');
//       setState(() {
//         _markerIcon = bmpd;
//         _markerIcon2 = bmpd2;
//         _markerIcon3 = bmpd3;
//         _markerIconFactory = bmpd4;
//       });
//     }
//   }
//
//   BitmapDescriptor? getMapIcon(String status) {
//     switch (status.toLowerCase()) {
//       case "driving":
//         return _markerIcon;
//       case "ign.off":
//         return _markerIcon2;
//       case "idling":
//         return _markerIcon3;
//       case "offline":
//         return _markerIcon2;
//       case "over speed":
//         return _markerIcon;
//     }
//     return _markerIcon;
//   }
//
//   BitmapDescriptor? _markerIconFactory;
//
//   bool isShowDetail = false;
//
//   showDetail() {
//     isDialOpen.value = false;
//     return InkWell(
//       onTap: () {
//         // Navigator.of(context)
//         //     .push(MaterialPageRoute(builder: (context) => HomeDetailPage()));
//         isDialOpen.value = false;
//         showBarModalBottomSheet(
//           expand: true,
//           context: context,
//           backgroundColor: Colors.transparent,
//           builder: (context) => HomeDetailPage(
//             vehicle: vehicleClick!,
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15.0),
//               topRight: Radius.circular(15.0),
//             )),
//         padding: EdgeInsets.all(5),
//         child: Column(
//           children: [
//             Image.asset(
//               "assets/images/line.png",
//               width: 40,
//               height: 5,
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Utils.statusCarImage(vehicleClick!.gps!.io_name!),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         vehicleClick!.info!.licenseplate!,
//                         style: TextStyle(
//                             color: ColorCustom.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text(vehicleClick!.info!.licenseprov!,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 12,
//                           )),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       Text(
//                         vehicleClick!.gps!.speed.toStringAsFixed(0),
//                         style: TextStyle(
//                             color: ColorCustom.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text('กม/ชม',
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 10,
//                           )),
//                     ],
//                   ),
//                   decoration:
//                       BoxDecoration(shape: BoxShape.circle, color: ColorCustom.greyBG2),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   advertise() {
//     return Stack(
//       alignment: Alignment.topRight,
//       children: [
//         Image.asset(
//           "assets/images/146.png",
//         ),
//         Container(
//           padding: EdgeInsets.all(10),
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 isAdvertise = false;
//               });
//             },
//             child: Icon(
//               Icons.close,
//               size: 30,
//               color: Colors.white,
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   bool isShowDetailFactory = false;
//
//   showDetailFactory() {
//     isDialOpen.value = false;
//     kLocations.clear();
//     return InkWell(
//         onTap: () {
//           setState(() {
//             isShowDetailFactory = false;
//             isShowDetail = false;
//             isShowDetailFactoryFull = true;
//           });
//         },
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15.0),
//                 topRight: Radius.circular(15.0),
//               )),
//           padding: EdgeInsets.all(5),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               Image.asset(
//                 "assets/images/icon_factory.png",
//                 height: 60,
//                 width: 60,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       factoryClick!.name!,
//                       style: TextStyle(
//                           color: ColorCustom.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(factoryClick!.iconPoint!,
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
//
//   bool isShowDetailFactoryFull = false;
//
//   showDetailFactoryFull() {
//     isDialOpen.value = false;
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15.0),
//             topRight: Radius.circular(15.0),
//           )),
//       padding: EdgeInsets.all(5),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               Image.asset(
//                 "assets/images/icon_factory.png",
//                 height: 60,
//                 width: 60,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       factoryClick!.name!,
//                       style: TextStyle(
//                           color: ColorCustom.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(factoryClick!.iconPoint!,
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.all(10),
//             margin: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               border: Border.all(color: ColorCustom.greyBG2),
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10.0),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.travel_explore,
//                       size: 30,
//                       color: Colors.grey,
//                     ),
//                     Text(
//                       'รายละเอียดสถานี',
//                       style: TextStyle(
//                         color: ColorCustom.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'ตำแหน่ง',
//                       style: TextStyle(
//                         color: ColorCustom.black,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       factoryClick!.location_name_3! +
//                           " " +
//                           factoryClick!.location_name_2! +
//                           " " +
//                           factoryClick!.location_name_1!,
//                       style: TextStyle(
//                         color: ColorCustom.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       'จำนวนรถทั้งหมดในสถานี',
//                       style: TextStyle(
//                         color: ColorCustom.black,
//                         fontSize: 16,
//                       ),
//                     ),
//                     InkWell(
//                       child: Text(
//                         factoryClick!.vid_list.length.toString() + ' คัน >',
//                         style: TextStyle(
//                           color: ColorCustom.blue,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       onTap: () {
//                         showCarList();
//                       },
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   TextEditingController searchController = new TextEditingController();
//   List<Vehicle> listSearch = [];
//
//   showCarList() {
//     isDialOpen.value = false;
//     for (Vehicle v in listVehicle) {
//       for (int vid in factoryClick!.vid_list) {
//         if (vid == v.info!.vid) {
//           listSearch.add(v);
//         }
//       }
//     }
//     // listSearch.addAll(listVehicle);
//     showBarModalBottomSheet(
//       expand: true,
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Column(
//         children: [
//           BackIOS(),
//           Container(
//             margin: EdgeInsets.all(10),
//             child: TextField(
//               keyboardType: TextInputType.text,
//               onChanged: (value) {
//                 listSearch.clear();
//                 for (Vehicle v in listVehicle) {
//                   if (v.info!.licenseplate!.contains(value)) {
//                     listSearch.add(v);
//                   }
//                   if (v.info!.licenseprov!.contains(value)) {
//                     listSearch.add(v);
//                   }
//                   if (v.info!.vin_no!.contains(value)) {
//                     listSearch.add(v);
//                   }
//                 }
//                 refresh();
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide(
//                     width: 0,
//                     style: BorderStyle.none,
//                   ),
//                 ),
//                 filled: true,
//                 fillColor: ColorCustom.greyBG2,
//                 prefixIcon: Icon(Icons.search),
//                 hintText: 'ค้นหา',
//                 hintStyle: TextStyle(fontSize: 16),
//                 // fillColor: colorSearchBg,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.all(10),
//               shrinkWrap: false,
//               itemCount: listSearch.length,
//               itemBuilder: (BuildContext context, int index) {
//                 Vehicle vehicle = listSearch[index];
//
//                 return GestureDetector(
//                   onTap: () {
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (_) =>
//                     //             HomeCarSummaryPage(vehicle: vehicle)));
//                     context.read<PageProvider>().selectVehicle(vehicle);
//                     Navigator.of(context)
//                         .popUntil(ModalRoute.withName('/root'));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 10),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: ColorCustom.greyBG2),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10.0),
//                       ),
//                     ),
//                     padding: EdgeInsets.only(
//                         top: 10, bottom: 10, left: 10, right: 10),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Utils.statusCarImage(vehicle.gps!.io_name!),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 vehicle.info!.licenseplate!,
//                                 style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Text(vehicle.info!.licenseprov!,
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   )),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Text(
//                               vehicle.gps!.speed.toStringAsFixed(0),
//                               style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text('กม/ชม',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 )),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   bool isShowInfo = false;
//
//   showInfo() {
//     isDialOpen.value = false;
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return InfoPage(count: listVehicle.length);
//         });
//   }
//
//   showNoti() {
//     isDialOpen.value = false;
//     showBarModalBottomSheet(
//       expand: true,
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => HomeNotiPage(),
//     );
//   }
//
//   showCar() {
//     isDialOpen.value = false;
//     showBarModalBottomSheet(
//       expand: true,
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => HomeCarPage(),
//     );
//   }
//
//   // showCarSummary(Vehicle vehicle) {
//   //   showBarModalBottomSheet(
//   //     expand: true,
//   //     context: context,
//   //     backgroundColor: Colors.transparent,
//   //     builder: (context) => HomeCarSummaryPage(
//   //       vehicle: vehicle,
//   //     ),
//   //   );
//   // }
//
//   showNews() {
//     isDialOpen.value = false;
//     showBarModalBottomSheet(
//       expand: true,
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => HomeNewsPage(),
//     );
//   }
//
//   Vehicle? vehicleClick;
//   Factory? factoryClick;
//
//   bool traffic = false;
//   MapType mode = MapType.normal;
//   bool isPinFactory = false;
//   bool isZoom = false;
//
//   @override
//   Widget build(BuildContext context) {
//     Vehicle? v = context.watch<PageProvider>().is_select_vehicle;
//     if (v != null) {
//       markerVehicleClick(v);
//       context.read<PageProvider>().selectVehicle(null);
//     }
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
//             isAdvertise ? advertise() : Container(),
//             Expanded(
//               child: Stack(
//                 children: [
//                   GoogleMap(
//                     trafficEnabled: traffic,
//                     mapType: mode,
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     zoomControlsEnabled: false,
//                     polylines: Set<Polyline>.of(_mapPolylines.values),
//
//                     initialCameraPosition: CameraPosition(
//                       zoom: 9,
//                       target: LatLng(13.7650836, 100.5379664),
//                     ),
//                     onMapCreated: (GoogleMapController controller) {
//                       if (!_controller.isCompleted) {
//                         _controller.complete(controller);
//                       }
//                       mapController = controller;
//                       _manager != null
//                           ? _manager.setMapId(controller.mapId)
//                           : null;
//                     },
//                     // onCameraMove:
//                     //     _manager != null ? _manager.onCameraMove : null,
//                     onCameraMove: (value){
//                       isZoom = true;
//                       if(_manager != null){
//                         _manager.onCameraMove(value);
//                       }
//                       // _manager != null ? _manager.onCameraMove(value):null;
//                     },
//                     onCameraIdle: _manager != null ? _manager.updateMap : null,
//                     // onCameraMove: (position) {
//                     //   _manager.onCameraMove(position);
//                     // },
//                     // onCameraIdle: () {
//                     //   _manager.updateMap.call();
//                     // },
//                     circles: this.circles != null ? circles! : circlesDef,
//                     markers: markers,
//                     // markers: Set<Marker>.of(_markersTruck),
//                   ),
//                   // Container(
//                   //   margin: EdgeInsets.all(10),
//                   //   child: FancyFab(
//                   //       onPressed: () {}, tooltip: "", icon: Icons.eleven_mp),
//                   // ),
//                   Container(
//                     alignment: Alignment.bottomLeft,
//                     margin: EdgeInsets.all(10),
//                     child: SpeedDial(
//                       renderOverlay: false,
//                       icon: Icons.handyman,
//                       backgroundColor: Colors.white,
//                       foregroundColor: ColorCustom.blue,
//                       activeIcon: Icons.close,
//                       activeForegroundColor: Colors.red,
//                       closeDialOnPop: true,
//                       openCloseDial: isDialOpen,
//                       children: [
//                         SpeedDialChild(
//                           onTap: () {
//                             if (mode == MapType.normal) {
//                               mode = MapType.satellite;
//                             } else {
//                               mode = MapType.normal;
//                             }
//                             refresh();
//                           },
//                           child: Icon(
//                             Icons.layers,
//                             color: mode == MapType.normal
//                                 ? Colors.grey
//                                 : ColorCustom.blue,
//                           ),
//                         ),
//                         // SpeedDialChild(
//                         //   onTap: () {
//                         //     if (isLicense) {
//                         //       isLicense = false;
//                         //     } else {
//                         //       isLicense = true;
//                         //     }
//                         //     // isLoaded = false;
//                         //     refresh();
//                         //     eneblePlate();
//                         //   },
//                         //   child: Icon(
//                         //     Icons.live_help,
//                         //     color: isLicense ? ColorCustom.blue : Colors.grey,
//                         //   ),
//                         // ),
//                         SpeedDialChild(
//                           onTap: () {
//                             isPinFactory
//                                 ? isPinFactory = false
//                                 : isPinFactory = true;
//
//                             listPlace.clear();
//                             // getData(context);
//
//                             for (Vehicle v in listVehicle) {
//                               listPlace.add(new Place(
//                                   latLng: LatLng(v.gps!.lat!, v.gps!.lng!),
//                                   vehicle: v));
//                             }
//                             if (isPinFactory) {
//                               for (Factory v in listFactory) {
//                                 listPlace.add(new Place(
//                                     latLng: LatLng(v.lat, v.lng), factory: v));
//                               }
//                             }
//                             updatePinRefresh();
//                           },
//                           child: Icon(
//                             Icons.cottage,
//                             color: isPinFactory ? ColorCustom.blue : Colors.grey,
//                           ),
//                         ),
//                         SpeedDialChild(
//                           onTap: () {
//                             if (traffic) {
//                               traffic = false;
//                             } else {
//                               traffic = true;
//                             }
//                             refresh();
//                           },
//                           child: Icon(
//                             Icons.traffic,
//                             color: traffic ? ColorCustom.blue : Colors.grey,
//                           ),
//                         ),
//                         SpeedDialChild(
//                           onTap: () {
//                             showInfo();
//                           },
//                           child: Icon(
//                             Icons.info,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.bottomRight,
//                     margin: EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         FloatingActionButton(
//                           onPressed: () {
//                             showNoti();
//                           },
//                           child: Icon(
//                             Icons.notifications,
//                             color: Colors.grey,
//                           ),
//                           backgroundColor: Colors.white,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         FloatingActionButton(
//                           onPressed: () {
//                             showCar();
//                           },
//                           child: Icon(Icons.menu),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.all(10),
//                     alignment: Alignment.topRight,
//                     child: FloatingActionButton(
//                       backgroundColor: Colors.white,
//                       onPressed: () {
//                         showNews();
//                       },
//                       child: Icon(
//                         Icons.email,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   isZoom?Container(
//                     margin: EdgeInsets.all(10),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         listPlace.clear();
//                         kLocations.clear();
//                         // isLoaded = false;
//
//                         isShowInfo = false;
//                         isShowDetail = false;
//                         isShowDetailFactory = false;
//                         // refresh();
//                         // getData(context);
//                         updatePinRefresh();
//                         mapController!.animateCamera(CameraUpdate.newLatLngZoom(
//                             LatLng(13.7650836, 100.5379664), 9));
//                         isZoom = false;
//                       },
//                       child: isShowDetail || isShowDetailFactory
//                           ? Icon(
//                               Icons.arrow_back,
//                               color: Colors.white,
//                               size: 30,
//                             )
//                           : Icon(
//                               Icons.refresh,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.grey,
//                         shape: CircleBorder(),
//                         padding: EdgeInsets.all(10),
//                       ),
//                     ),
//                   ):Container(),
//                 ],
//               ),
//             ),
//             isShowDetail ? showDetail() : Container(),
//             isShowDetailFactory ? showDetailFactory() : Container(),
//             isShowDetailFactoryFull ? showDetailFactoryFull() : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
