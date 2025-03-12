// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hino/model/channel.dart';
// import 'package:hino/model/vehicle_detail.dart';
// import 'package:hino/page/video_player.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/utils/marker_license.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
//
// class HomeDetailCCTVPage extends StatefulWidget {
//   const HomeDetailCCTVPage({Key? key, required this.vd}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//   final VehicleDetail vd;
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeDetailCCTVPage> {
//   VehicleDetail? vehicleDetail;
//   List<Channel> list = [];
//
//   @override
//   void initState() {
//     vehicleDetail = widget.vd;
//     list.addAll(vehicleDetail!.optionMvr!.channel!);
//     playAll();
//     checkPermission();
//     super.initState();
//   }
//
//   checkPermission() async {
//     var status = await Permission.manageExternalStorage.status;
//     if (status.isDenied) {
//       if (await Permission.manageExternalStorage.request().isGranted) {
//         // Either the permission was already granted before or the user just granted it.
//       }
//     }
//     var status2 = await Permission.storage.status;
//     if (status2.isDenied) {
//       if (await Permission.storage.request().isGranted) {
//         // Either the permission was already granted before or the user just granted it.
//       }
//     }
//   }
//
//   Future<void> requestPermission(Permission permission) async {
//     final status = await permission.request();
//
//     setState(() {});
//   }
//
//   ScreenshotController screenshotController = ScreenshotController();
//
//   int captureMilli = 0;
//   bool isSnaping = false;
//
//   capture() async {
//     isSnaping = true;
//     setState(() {});
//     // screenshotController.capture().then((Uint8List? image) {
//     //   if (image != null) {
//     //
//     //   }
//     // }).catchError((onError) {
//     //   print(onError);
//     // });
//     // final directory = (await getApplicationDocumentsDirectory())
//     //     .path; //from path_provide package
//     // String fileNameA = DateTime.now().microsecondsSinceEpoch.toString();
//     // var path = '$directory';
//     //
//     // screenshotController.captureAndSave(path, fileName: fileNameA);
//
//     for (Channel c in list) {
//       if (c.select) {
//         // c.controller!.position.then((value) async => {
//         //       print(_printDuration(value!)),
//         //       await VideoThumbnail.thumbnailFile(
//         //           video: c.url!,
//         //           thumbnailPath:
//         //               (await getApplicationDocumentsDirectory()).path,
//         //           imageFormat: ImageFormat.JPEG,
//         //           // maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//         //           quality: 100,
//         //           timeMs: 0),
//         //     });
//         readByte(c.url!, c.controller!);
//       }
//     }
//   }
//
//   bool isShowSnapshot = false;
//
//   readByte(String url, VideoPlayerController videoPlayerController) async {
//     Uint8List? bytes = await VideoThumbnail.thumbnailData(
//       video: url, // Path of that video
//       imageFormat: ImageFormat.JPEG,
//       quality: 90,
//       timeMs: 0,
//     );
//     if (bytes != null) {
//       final resultsave = await ImageGallerySaver.saveImage(
//           Uint8List.fromList(bytes),
//           quality: 100,
//           name: 'screenshot-${DateTime.now()}.jpg');
//       print(resultsave);
//       if (!isShowSnapshot) {
//         isSnaping = false;
//         showAlertDialogSnap(context, "Snapshot Success");
//       }
//     }
//   }
//
//   showAlertDialogSnap(BuildContext context, String message) {
//     // set up the button
//     Widget okButton = FlatButton(
//       child: Text("OK"),
//       onPressed: () {
//         isShowSnapshot = false;
//         Navigator.pop(context);
//       },
//     );
//
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       content: Text(message),
//       actions: [
//         okButton,
//       ],
//     );
//
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         isShowSnapshot = true;
//         return alert;
//       },
//     );
//   }
//
//   final GlobalKey _key = GlobalKey();
//
//   void _CaptureScreenShot() async {
//     //get paint bound of your app screen or the widget which is wrapped with RepaintBoundary.
//     RenderRepaintBoundary bound =
//         _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
//
//     if (bound.debugNeedsPaint) {
//       Timer(Duration(seconds: 1), () => _CaptureScreenShot());
//       return null;
//     }
//
//     ui.Image image = await bound.toImage();
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//
//     // this will save image screenshot in gallery
//     if (byteData != null) {
//       Uint8List pngBytes = byteData.buffer.asUint8List();
//       final resultsave = await ImageGallerySaver.saveImage(
//           Uint8List.fromList(pngBytes),
//           quality: 90,
//           name: 'screenshot-${DateTime.now()}.png');
//       print(resultsave);
//     }
//   }
//
//   String _printDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }
//
//   refresh() {
//     setState(() {});
//   }
//
//   playAll() {
//     for (Channel c in list) {
//       c.select = true;
//       if (c.url != null) {
//         c.controller = VideoPlayerController.network(c.url!,
//             videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
//           ..initialize().then((value) => {c.controller!.play(), refresh()});
//       }
//     }
//     refresh();
//   }
//
//   stopAll() {
//     for (Channel c in list) {
//       c.select = false;
//       c.controller!.pause();
//     }
//     refresh();
//   }
//
//   bool isMute = false;
//
//   mute() {
//     for (Channel c in list) {
//       if (c.controller != null) {
//         c.controller!.setVolume(isMute ? 0 : 1);
//       }
//     }
//     refresh();
//   }
//
//   Set<Marker> markers = Set();
//
//   pinBtn() {
//     for (Channel c in list) {
//       if (c.channel == -1) {
//         return;
//       }
//     }
//     if (list.length >= 3) {
//       list.insert(3, Channel("pin", -1, ""));
//     } else {
//       list.add(Channel("pin", -1, ""));
//     }
//     markers.add(Marker(
//       markerId: MarkerId(vehicleDetail!.info!.vid!.toString()),
//       position: LatLng(vehicleDetail!.gps!.lat!, vehicleDetail!.gps!.lng!),
//       onTap: () {},
//       anchor: const Offset(0.5, 0.5),
//       // infoWindow: InfoWindow(
//       //     title: v!.info!.vehicle_name, anchor: Offset(0.5, 0.5)),
//       // icon: getMapIcon(v!)!,
//       icon: MarkerLicense.iconTest!,
//     ));
//     refresh();
//   }
//
//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }
//
//   // getData(BuildContext context) {
//   //   Api.get(context, Api.vid_detail + vehicleDetail!.info!.vid.toString())
//   //       .then((value) => {
//   //     if (value != null)
//   //       {vehicleDetail = VehicleDetail.fromJson(value), refresh()}
//   //     else
//   //       {}
//   //   });
//   // }
//
//   @override
//   void dispose() {
//     for (Channel c in list) {
//       c.controller!.dispose();
//     }
//     super.dispose();
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
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(left: 5),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   childAspectRatio: (1 / 1),
//                   controller: new ScrollController(keepScrollOffset: false),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   children: list.map((Channel value) {
//                     return Container(
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.only(right: 5, bottom: 5),
//                       color: ColorCustom.greyBG,
//                       child: value.channel == -1
//                           ? Container(
//                               child: GoogleMap(
//                                 myLocationEnabled: true,
//                                 myLocationButtonEnabled: true,
//                                 zoomControlsEnabled: false,
//                                 mapToolbarEnabled: false,
//                                 initialCameraPosition: CameraPosition(
//                                   zoom: 14,
//                                   target: LatLng(vehicleDetail!.gps!.lat!,
//                                       vehicleDetail!.gps!.lng!),
//                                 ),
//                                 markers: markers,
//                               ),
//                             )
//                           : InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) => VideoPlayerView(
//                                               url: value.url!,
//                                             )));
//                                 // value.controller!.play();
//                               },
//                               child: Column(
//                                 children: [
//                                   Expanded(
//                                     child: Center(
//                                       child:
//                                           value.controller!.value.isInitialized
//                                               ? AspectRatio(
//                                                   aspectRatio: value.controller!
//                                                       .value.aspectRatio,
//                                                   child: VideoPlayer(
//                                                       value.controller!),
//                                                 )
//                                               : CircularProgressIndicator(),
//                                     ),
//                                   ),
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(Icons.videocam),
//                                       Text(
//                                         value.labelName!,
//                                         style: TextStyle(
//                                           color: ColorCustom.black,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             isSnaping
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Container(),
//             Container(
//               color: ColorCustom.greyBG,
//               height: 60,
//               padding: EdgeInsets.only(left: 10, right: 10),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.arrow_back_ios,
//                     size: 20,
//                     color: Colors.grey,
//                   ),
//                   Expanded(
//                     child: ListView(
//                       padding: EdgeInsets.all(5),
//                       scrollDirection: Axis.horizontal,
//                       children: List.generate(
//                           vehicleDetail!.optionMvr!.channel!.length,
//                           (int index) {
//                         Channel s = vehicleDetail!.optionMvr!.channel![index];
//
//                         return InkWell(
//                           onTap: () {
//                             if (s.select) {
//                               s.controller!.pause();
//                             } else {
//                               s.controller = VideoPlayerController.network(
//                                   s.url!,
//                                   videoPlayerOptions:
//                                       VideoPlayerOptions(mixWithOthers: true))
//                                 ..initialize().then((value) =>
//                                     {s.controller!.play(), refresh()});
//                             }
//
//                             s.select = !s.select;
//                             refresh();
//                           },
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Icon(
//                                 Icons.videocam,
//                                 color: s.select ? Colors.blue : Colors.grey,
//                               ),
//                               Text(
//                                 s.channel.toString(),
//                                 style: TextStyle(
//                                   color: ColorCustom.black,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios,
//                     size: 20,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               color: ColorCustom.greyBG,
//               padding: EdgeInsets.all(20),
//               child: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(width: 1, color: Colors.grey)),
//                     child: InkWell(
//                       onTap: () {
//                         isMute = !isMute;
//                         mute();
//                         refresh();
//                       },
//                       child: Padding(
//                           child: Icon(
//                             isMute ? Icons.volume_off : Icons.volume_up,
//                             color: Colors.black,
//                             size: 30,
//                           ),
//                           padding: EdgeInsets.all(3)),
//                     ),
//                   ),
//                   Expanded(child: Container()),
//                   Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(100),
//                           border: Border.all(width: 1, color: Colors.grey)),
//                       child: InkWell(
//                         onTap: () {
//                           capture();
//                         },
//                         child: Padding(
//                             child: Icon(
//                               Icons.camera_alt,
//                               color: Colors.black,
//                               size: 30,
//                             ),
//                             padding: EdgeInsets.all(3)),
//                       )),
//                   Expanded(child: Container()),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(width: 1, color: Colors.grey)),
//                     child: InkWell(
//                       child: Padding(
//                           child: Icon(
//                             Icons.live_tv_outlined,
//                             color: Colors.black,
//                             size: 40,
//                           ),
//                           padding: EdgeInsets.all(5)),
//                       onTap: () {
//                         playAll();
//                       },
//                     ),
//                   ),
//                   Expanded(child: Container()),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(width: 1, color: Colors.grey)),
//                     child: InkWell(
//                       child: Padding(
//                           child: Icon(
//                             Icons.pin_drop,
//                             color: Colors.black,
//                             size: 30,
//                           ),
//                           padding: EdgeInsets.all(3)),
//                       onTap: () {
//                         pinBtn();
//                       },
//                     ),
//                   ),
//                   Expanded(child: Container()),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(width: 1, color: Colors.grey)),
//                     child: Padding(
//                         child: Icon(
//                           Icons.zoom_out_map,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                         padding: EdgeInsets.all(3)),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
