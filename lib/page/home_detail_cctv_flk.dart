// import 'dart:async';
// import 'dart:ui' as ui;
//
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:iov/model/channel.dart';
// import 'package:iov/model/vehicle_detail.dart';
// import 'package:iov/page/home_detail_cctv_flk_map.dart';
// import 'package:iov/utils/color_custom.dart';
// import 'package:iov/utils/marker_license.dart';
// import 'package:iov/utils/utils.dart';
// import 'package:iov/widget/back_ios.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';
//
// import '../widget/custom_ui.dart';
//
// class HomeDetailCCTVPageFlk extends StatefulWidget {
//   const HomeDetailCCTVPageFlk({Key? key, required this.vd}) : super(key: key);
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
// class _PageState extends State<HomeDetailCCTVPageFlk> {
//   VehicleDetail? vehicleDetail;
//   List<Channel> list = [];
//
//   @override
//   void initState() {
//     vehicleDetail = widget.vd;
//     list.addAll(vehicleDetail!.optionMvr!.channel!);
//     initFirst();
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
// /*  capture() async {
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
//         readByte(c.url!);
//       }
//     }
//   }*/
//
//   bool isShowSnapshot = false;
//
// /*  readByte(String url) async {
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
//   }*/
//
//   showAlertDialogSnap(BuildContext context, String message) {
//     // set up the button
//     Widget okButton = ElevatedButton(
//       child: const Text("OK"),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: ColorCustom.primaryColor, // Set the background color here
//       ),
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
// /*  final GlobalKey _key = GlobalKey();
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
//   }*/
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
//   initFirst() async {
//     for (Channel c in list) {
//       c.select = false;
//       if (c.url != null) {
//         c.player = FijkPlayer();
//         c.player?.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
//         c.player?.setOption(
//             FijkOption.playerCategory,
//             "mediacodec-all-videos"
//             "",
//             1);
//
//         await c.player
//             ?.setOption(FijkOption.hostCategory, "request-screen-on", 1);
//         await c.player
//             ?.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
//         await c.player
//             ?.setDataSource(c.url!, autoPlay: false, showCover: true)
//             .catchError((e) {
//           print("setDataSource error: $e");
//         });
//       }
//     }
//     refresh();
//   }
//
//   bool isPlay = false;
//   bool clickBtn = false;
//
//   playAll() async {
//     isPlay = true;
//     clickBtn = true;
//     for (Channel c in list) {
//       if (c.player != null && c.player!.isPlayable()) {
//         c.select = true;
//         c.player!.start();
//       }
//     }
//     refresh();
//   }
//
//   stopAll() {
//     isPlay = false;
//     clickBtn = true;
//     for (Channel c in list) {
//       if (c.player != null && c.player!.isPlayable()) {
//         c.select = false;
//         c.player!.pause();
//       }
//
//     }
//     refresh();
//   }
//
//   bool isMute = false;
//
//   mute() {
//     for (Channel c in list) {
//       if (c.player != null) {
//         c.player!.setVolume(isMute ? 0 : 1);
//       }
//     }
//     refresh();
//   }
//
//   Set<Marker> markers = {};
//   final controller = Completer<GoogleMapController>();
//
//   pinBtn() {
//     bool isAddMap = false;
//     for (Channel c in list) {
//       if (c.channel == -1) {
//         isAddMap = true;
//       }
//     }
//     if (!isAddMap) {
//       if (list.length >= 3) {
//         list.insert(3, Channel("pin", -1, ""));
//       } else {
//         list.add(Channel("pin", -1, ""));
//       }
//     }
//     setState(() {
//       isMapLoad = true;
//     });
//     Future.delayed(const Duration(milliseconds: 400), () {
//       setState(() {
//         isMapLoad = false;
//       });
//     });
//     var vehicleRealtime =
//         Utils.getVehicleByVinNo(vehicleDetail!.info!.vin_no.toString());
//     if (vehicleRealtime != null) {
//       controller.future.then((value) => {
//             value.moveCamera(CameraUpdate.newLatLngZoom(
//                 LatLng(vehicleRealtime.gps!.lat!, vehicleRealtime.gps!.lng!),
//                 16))
//           });
//       vehicleDetail?.gps = vehicleRealtime.gps;
//       var a = Marker(
//         markerId: MarkerId(vehicleDetail!.info!.vid!.toString()),
//         position: LatLng(vehicleRealtime.gps!.lat!, vehicleRealtime.gps!.lng!),
//         onTap: () {},
//         anchor: const Offset(0.5, 0.5),
//         // infoWindow: InfoWindow(
//         //     title: v!.info!.vehicle_name, anchor: Offset(0.5, 0.5)),
//         // icon: getMapIcon(v!)!,
//         icon: MarkerLicense.iconTest!,
//       );
//       markers.clear();
//       markers.add(a);
//     }
//
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
//       c.player!.release();
//     }
//     super.dispose();
//   }
//
//   deselectFullScreen() {
//     for (Channel c in list) {
//       // c.select = false;
//       c.selectFullScreen = false;
//     }
//   }
//
//   Channel? getSelectFullScreen() {
//     for (Channel c in list) {
//       if (c.selectFullScreen) {
//         return c;
//       }
//     }
//     return null;
//   }
//
//   Channel? getSelect() {
//     for (Channel c in list) {
//       if (c.select) {
//         return c;
//       }
//     }
//     return null;
//   }
//
//   FijkPlayer? getPlayerByValue(int channel) {
//     for (Channel c in list) {
//       if (c.channel == channel) {
//         return c.player;
//       }
//     }
//     return null;
//   }
//
//   snapshot() async {
//     Channel? channel = getSelect();
//     if (channel?.player != null) {
//       String name = "${DateFormat('ddMMyyyyHHmm').format(DateTime.now())}Cam${channel!.channel}";
//       print("snapshot:$name");
//       var imageData = await channel.player?.takeSnapShot();
//       final resultsave = await ImageGallerySaver.saveImage(
//           Uint8List.fromList(imageData!),
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
//   // Widget cameraIcon(FijkPlayer? player) {
//   //   Future.delayed(const Duration(milliseconds: 200), () {
//   //     return Icon(
//   //       Icons.videocam,
//   //       color: player?.state == FijkState.started ? Colors.blue : Colors.grey,
//   //     );
//   //   });
//   //
//   //   return Icon(
//   //     Icons.videocam,
//   //     color: player?.state == FijkState.started ? Colors.red : Colors.grey,
//   //   );
//   // }
//
//   bool isMapLoad = false;
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
//             const BackIOS(),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(left: 5),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   childAspectRatio: (1 / 1),
//                   controller: ScrollController(keepScrollOffset: false),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   children: list.map((Channel value) {
//                     return Container(
//                       alignment: Alignment.center,
//                       margin: const EdgeInsets.only(right: 5, bottom: 5),
//                       decoration: BoxDecoration(
//                           color: ColorCustom.greyBG,
//                           border: Border.all(
//                               color: value.selectFullScreen
//                                   ? Colors.green
//                                   : ColorCustom.greyBG)),
//                       child: value.channel == -1
//                           ? Stack(
//                               children: [
//                                 GoogleMap(
//                                   myLocationEnabled: true,
//                                   myLocationButtonEnabled: true,
//                                   zoomControlsEnabled: false,
//                                   rotateGesturesEnabled: false,
//                                   scrollGesturesEnabled: false,
//                                   tiltGesturesEnabled: false,
//                                   zoomGesturesEnabled: false,
//                                   mapToolbarEnabled: false,
//                                   onMapCreated: (gController) {
//                                     controller.complete(gController);
//                                   },
//                                   initialCameraPosition: CameraPosition(
//                                     zoom: 14,
//                                     target: LatLng(vehicleDetail!.gps!.lat!,
//                                         vehicleDetail!.gps!.lng!),
//                                   ),
//                                   markers: markers,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     deselectFullScreen();
//                                     value.selectFullScreen = true;
//                                     refresh();
//                                   },
//                                   child: Container(),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.topRight,
//                                   child: IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         list.remove(value);
//                                       });
//                                     },
//                                     icon: const Icon(
//                                       Icons.close,
//                                       size: 20,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                                 isMapLoad
//                                     ? const Center(
//                                         child: CircularProgressIndicator(color: ColorCustom.primaryColor),
//                                       )
//                                     : Container()
//                               ],
//                             )
//                           : InkWell(
//                               onTap: () {
//                                 deselectFullScreen();
//                                 value.selectFullScreen = true;
//                                 refresh();
//                                 // Navigator.push(
//                                 //     context,
//                                 //     MaterialPageRoute(
//                                 //         builder: (_) => VideoPlayerViewFlk(
//                                 //               url: value.url!,
//                                 //             )));
//                                 // value.controller!.play();
//                               },
//                               child: Column(
//                                 children: [
//                                   Expanded(
//                                     child: Center(
//                                       child: value.player != null
//                                           ? FijkView(
//                                               player: value.player!,
//                                               // panelBuilder: simplestUI,
//                                               fsFit: FijkFit.fill,
//                                               // panelBuilder: simplestUI,
//                                               panelBuilder: (FijkPlayer player,
//                                                   FijkData data,
//                                                   BuildContext context,
//                                                   Size viewSize,
//                                                   Rect texturePos) {
//                                                 return CustomFijkPanel(
//                                                     player: player,
//                                                     buildContext: context,
//                                                     viewSize: viewSize,
//                                                     texturePos: texturePos);
//                                               },
//                                             )
//                                           : Container(),
//                                     ),
//                                   ),
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.videocam),
//                                       Text(
//                                         value.labelName!,
//                                         style: const TextStyle(
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
//                 ? const Center(
//                     child: CircularProgressIndicator(color: ColorCustom.primaryColor),
//                   )
//                 : Container(),
//             Container(
//               color: ColorCustom.greyBG,
//               height: 60,
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.arrow_back_ios,
//                     size: 20,
//                     color: Colors.grey,
//                   ),
//                   Expanded(
//                     child: ListView(
//                       padding: const EdgeInsets.all(5),
//                       scrollDirection: Axis.horizontal,
//                       children: List.generate(
//                           vehicleDetail!.optionMvr!.channel!.length,
//                           (int index) {
//                         Channel s = vehicleDetail!.optionMvr!.channel![index];
//                         FijkPlayer? player = getPlayerByValue(s.channel!);
//                         if(clickBtn){
//                           clickBtn = false;
//                           Future.delayed(const Duration(milliseconds: 150), () {
//                             setState(() {
//                               player = getPlayerByValue(s.channel!);
//                             });
//                           });
//                         }
//
//                         return InkWell(
//                           onTap: () {
//                             // if (s.select) {
//                             //   s.player!.stop();
//                             // } else {
//                             //   s.player!.start();
//                             // }
//                             //
//                             // s.select = !s.select;
//                             // refresh();
//                           },
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Icon(
//                                 Icons.videocam,
//                                 color: player?.state == FijkState.started
//                                     ? Colors.green
//                                     : Colors.grey,
//                               ),
//                               Text(
//                                 s.channel.toString(),
//                                 style: const TextStyle(
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
//                   const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 20,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               color: ColorCustom.greyBG,
//               padding: const EdgeInsets.all(20),
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
//                           padding: const EdgeInsets.all(3),
//                           child: Icon(
//                             isMute ? Icons.volume_off : Icons.volume_up,
//                             color: Colors.black,
//                             size: 30,
//                           )),
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
//                           // capture();
//                           snapshot();
//                         },
//                         child: const Padding(
//                             padding: EdgeInsets.all(3),
//                             child: Icon(
//                               Icons.camera_alt,
//                               color: Colors.black,
//                               size: 30,
//                             )),
//                       )),
//                   Expanded(child: Container()),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(width: 1, color: Colors.grey)),
//                     child: InkWell(
//                       child: Padding(
//                           padding: const EdgeInsets.all(5),
//                           child: isPlay
//                               ? const Icon(
//                                   Icons.stop_circle_outlined,
//                                   color: Colors.black,
//                                   size: 40,
//                                 )
//                               : const Icon(
//                                   Icons.live_tv_outlined,
//                                   color: Colors.black,
//                                   size: 40,
//                                 )),
//                       onTap: () {
//                         if (isPlay) {
//                           stopAll();
//                         } else {
//                           playAll();
//                         }
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
//                       child: const Padding(
//                           padding: EdgeInsets.all(3),
//                           child: Icon(
//                             Icons.location_on,
//                             color: Colors.black,
//                             size: 30,
//                           )),
//                       onTap: () {
//                         pinBtn();
//                       },
//                     ),
//                   ),
//                   Expanded(child: Container()),
//                   InkWell(
//                     onTap: () {
//                       Channel? c = getSelectFullScreen();
//                       if (c?.channel == -1) {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => HomeDetailCCTVMapsPage(
//                                   vehicleDetail: vehicleDetail!,
//                                 )));
//                       } else {
//                         getSelectFullScreen()?.player!.enterFullScreen();
//                       }
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(100),
//                           border: Border.all(width: 1, color: Colors.grey)),
//                       child: const Padding(
//                           padding: EdgeInsets.all(3),
//                           child: Icon(
//                             Icons.zoom_out_map,
//                             color: Colors.black,
//                             size: 30,
//                           )),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
