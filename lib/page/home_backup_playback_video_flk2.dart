// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';
//
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';
// import 'package:iov/model/cctv_vehicle.dart';
// import 'package:iov/page/home_backup_playback_video_flk_maps.dart';
// import 'package:iov/utils/color_custom.dart';
// import 'package:iov/widget/actionbar_back.dart';
// import 'package:iov/widget/map_playback.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:intl/intl.dart';
//
// import '../api/api.dart';
// import '../model/cctv_date_channel.dart';
// import '../model/channel.dart';
// import '../widget/custom_ui.dart';
//
// class HomeBackupPlaybackVideoPageFlk2 extends StatefulWidget {
//   const HomeBackupPlaybackVideoPageFlk2(
//       {Key? key,
//       required this.date,
//       required this.listChannel,
//       required this.cctvVehicle,
//       required this.device,
//       required this.start,
//       required this.end})
//       : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this he App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//   final String date;
//   final List<CctvDateChannel> listChannel;
//   final CctvVehicle cctvVehicle;
//   final String device;
//   final String start;
//   final String end;
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<HomeBackupPlaybackVideoPageFlk2> {
//   List<double> playbackSpeeds = [0.5, 1.0, 2.0];
//   int playbackSpeedIndex = 1;
//   final double initSnapshotRightPosition = 10;
//   final double initSnapshotBottomPosition = 10;
//
//   @override
//   void initState() {
//     getLive(context);
//     getData2(context);
//     timerVideo =
//         Timer.periodic(const Duration(seconds: 1), (Timer t) => listenerTimer());
//     super.initState();
//   }
//
//   refresh() {
//     setState(() {});
//   }
//
//   // channel=1&start=2022-06-01%2018:48:24&end=2022-06-01%2018:49:03
//   // https://api-center.onelink-iot.com/prod/fleet/mdvr/playback/info?&user_id=27&vehicle_id=30471&channel=1,2,3,4&start=2022-11-03%2000:00:00&end=2022-11-03%2023:59:59&ft=0&st=1
//
//   List<Channel> listUrl = [];
//
//   // https://stream.onelink-iot.com/play/0071006265/1/1-0-114_20221101110141_20221101110150_21.ts
//   // https://stream.onelink-iot.com/play/0071006265/1/20221101000000_20221101235959_main.m3u8
//   getLive(BuildContext context) {
//     int count = 0;
//     for (CctvDateChannel c in widget.listChannel) {
//       Api.get(
//               context,
//               "${Api.cctv_live}${Api.profile!.userId}&vehicle_id=${widget.cctvVehicle.vehicleId}&channel=${c.channel_id}&start=${widget.start}&end=${widget.end}&ft=0&st=${widget.device}")
//           .then((value) => {
//                 if (value != null)
//                   {
//                     count++,
//                     for (var res in value["result"])
//                       {
//                         listUrl.add(
//                             Channel(c.label_name!, c.channel_id!, res["url"]))
//                       },
//                     listUrl.sort((a, b) => a.channel!.compareTo(b.channel!)),
//                     if (count == widget.listChannel.length) {initAll()}
//                   }
//                 else
//                   {}
//               });
//     }
//   }
//
//   List data = [];
//   MapPlaybackWidget? mapsWidget;
//   int index = 0;
//
//   getData2(BuildContext context) {
//     List list = [];
//     String param = "?user_id=${Api.profile!.userId}&vid=${widget.cctvVehicle.vehicleId}&start=${widget.start}&end=${widget.end}";
//     Api.get(context, Api.trip_detail + param).then((value) => {
//           if (value != null)
//             {
//               data = value,
//               log(value.toString()),
//               mapsWidget = MapPlaybackWidget(
//                 vid: widget.cctvVehicle.vehicleId.toString(),
//                 listRoute: data,
//                 positionChange: (value) {
//                   index = value;
//                 },
//               ),
//             }
//           else
//             {},
//         });
//   }
//
//   bool isPlayAll = false;
//
//   initAll() async {
//     isPlayAll = false;
//     for (Channel c in listUrl) {
//       c.select = false;
//       print(c.url!);
//       if (c.url != null) {
//         // c.controller = VideoPlayerController.network(c.url!,
//         //     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
//         //   ..initialize().then((value) => {c.controller!.play(), refresh()});
//
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
//         // if(!c.player!.hasListeners){
//         //   c.player?.addListener(() {
//         //
//         //     if (c.player!.isPlayable()) {
//         //       print("listener   "+c.player!.currentPos.toString());
//         //       max = c.player!.value.duration.inSeconds;
//         //       var oPosition = c.player!.currentPos;
//         //       var oDuration = c.player!.value.duration;
//         //       // sliderValue = oPosition.inSeconds;
//         //       // print(oPosition.inSeconds);
//         //
//         //       if (oDuration.inHours == 0) {
//         //         var strPosition = oPosition.toString().split('.')[0];
//         //         var strDuration = oDuration.toString().split('.')[0];
//         //         position =
//         //         "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
//         //         duration =
//         //         "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
//         //       } else {
//         //         position = oPosition.toString().split('.')[0];
//         //         duration = oDuration.toString().split('.')[0];
//         //       }
//         //       validPosition = oDuration.compareTo(oPosition) >= 0;
//         //       sliderValue = validPosition ? oPosition.inSeconds : 0;
//         //
//         //       setState(() {});
//         //     }
//         //
//         //   });
//         // }
//         // if (!isAddListener) {
//         //   c.player?.addListener(listener);
//         //   isAddListener = true;
//         // }
//       }
//     }
//     refresh();
//   }
//
//   int max = 100;
//   int sliderValue = 0;
//   String position = '0';
//   String duration = '0';
//   bool validPosition = false;
//
//   Timer? timerVideo;
//
//   // VlcPlayerController? _controller;
//   //
//   void listenerTimer() async {
//     if (!mounted) return;
//     //
//     FijkPlayer? controller = getPlayVideo()?.player;
//     if (controller != null && controller.isPlayable()) {
//       // _controller.onCurrentPosUpdate.listen((event) {
//       //   setState(() {
//       //     sliderValue = event.inSeconds;
//       //     position = event.inSeconds.toString();
//       //   });
//       // });
//       print("listener   ${controller.currentPos}");
//       setState(() {
//         sliderValue = controller.currentPos.inSeconds;
//         position = controller.currentPos.inSeconds.toString();
//         _currentPos = controller.currentPos;
//       });
//       max = controller.value.duration.inSeconds;
//       duration = controller.value.duration.inSeconds.toString();
//       _duration = controller.value.duration;
//       mapsDuration = _duration;
//
//       // timer?.cancel();
//       // var oPosition = _controller.currentPos;
//       // var oDuration = _controller.value.duration;
//       // // sliderValue = oPosition.inSeconds;
//       // // print(oPosition.inSeconds);
//       //
//       // if (oPosition != null && oDuration != null) {
//       //   if (oDuration.inHours == 0) {
//       //     var strPosition = oPosition.toString().split('.')[0];
//       //     var strDuration = oDuration.toString().split('.')[0];
//       //     position =
//       //         "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
//       //     duration =
//       //         "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
//       //   } else {
//       //     position = oPosition.toString().split('.')[0];
//       //     duration = oDuration.toString().split('.')[0];
//       //   }
//       //   validPosition = oDuration.compareTo(oPosition) >= 0;
//       //   sliderValue = validPosition ? oPosition.inSeconds : 0;
//       // }
//
//       setState(() {});
//     }
//   }
//
//   // void _onSliderPositionChanged(double progress) {
//   //   setState(() {
//   //     sliderValue = progress;
//   //   });
//   //   //convert to Milliseconds since VLC requires MS to set time
//   //   for (Channel c in listUrl) {
//   //     if (c.controllerVlc != null && c.controllerVlc!.value.isPlaying) {
//   //       c.controllerVlc!.setTime(sliderValue.toInt() * 1000);
//   //     }
//   //   }
//   // }
//
//   playAll() {
//     isPlayAll = true;
//     for (Channel c in listUrl) {
//       // c.select = true;
//       c.player?.start();
//     }
//     mapsPlay = true;
//     refresh();
//   }
//
//   stopAll() {
//     isPlayAll = false;
//     for (Channel c in listUrl) {
//       // c.select = false;
//       c.player?.pause();
//     }
//     mapsPlay = false;
//     refresh();
//   }
//
//   deselect() {
//     for (Channel c in listUrl) {
//       // c.select = false;
//       c.select = false;
//     }
//   }
//
//   Channel? getSelect() {
//     for (Channel c in listUrl) {
//       if (c.select) {
//         return c;
//       }
//     }
//     return null;
//   }
//
//   Channel? getPlayVideo() {
//     for (Channel c in listUrl) {
//       if (c.player?.state == FijkState.started) {
//         return c;
//       }
//     }
//     return null;
//   }
//
//   nextPosition() async {
//     isPlayAll = true;
//     for (Channel c in listUrl) {
//       if (c.player != null && c.player!.state == FijkState.started) {
//         await c.player!.seekTo(c.player!.currentPos.inMilliseconds +
//             const Duration(seconds: 10).inMilliseconds);
//       }
//     }
//   }
//
//   backPosition() async {
//     isPlayAll = true;
//     for (Channel c in listUrl) {
//       if (c.player != null && c.player!.state == FijkState.started) {
//         await c.player!.seekTo(c.player!.currentPos.inMilliseconds +
//             const Duration(seconds: -10).inMilliseconds);
//       }
//     }
//   }
//
//   void _restartHideTimer() {
//     timerVideo?.cancel();
//     timerVideo =
//         Timer.periodic(const Duration(seconds: 1), (Timer t) => listenerTimer());
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     timerVideo?.cancel();
//     for (Channel c in listUrl) {
//       c.player?.release();
//     }
//   }
//
//   bool isShowSnapshot = false;
//
//   snapshot() async {
//     // 280820211604Cam1
//     Channel? channel = getSelect();
//     if (channel?.player != null) {
//       String name = "${DateFormat('ddMMyyyyHHmm').format(DateTime.now())}Cam${channel!.channel}";
//       print("snapshot:$name");
//       var imageData = await channel.player?.takeSnapShot();
//       final resultsave = await ImageGallerySaver.saveImage(
//           Uint8List.fromList(imageData!),
//           quality: 100,
//           name: '$name.jpg');
//       print(resultsave);
//       if (!isShowSnapshot) {
//         showAlertDialogSnap(context, "Snapshot Success");
//       }
//     }
//   }
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
//   pinBtn() {
//     for (Channel c in listUrl) {
//       if (c.channel == -1) {
//         return;
//       }
//     }
//     if (listUrl.length >= 3) {
//       listUrl.insert(3, Channel("pin", -1, ""));
//     } else {
//       listUrl.add(Channel("pin", -1, ""));
//     }
//
//     refresh();
//   }
//
//   String formatTime(int seconds) {
//     return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
//   }
//
//   onTickChange(value) {}
//
//   bool isSeek = false;
//   String textPosition = "00:00";
//
//   double _seekPos = -1.0;
//   Duration _duration = const Duration();
//   Duration _currentPos = const Duration();
//
//   double dura2double(Duration d) {
//     return d.inMilliseconds.toDouble();
//   }
//
//   double currentValue = 0;
//
//   Widget buildSlider(BuildContext context) {
//     double duration = dura2double(_duration);
//
//     currentValue = _seekPos > 0 ? _seekPos : dura2double(_currentPos);
//     currentValue = currentValue.clamp(0.0, duration);
//
//     return Slider(
//       min: 0.0,
//       max: duration,
//       value: currentValue,
//       onChangeEnd: (value) {
//         print(value.toString());
//         print("MAX   $max");
//         for (Channel c in listUrl) {
//           if (c.player != null) {
//             setState(() {
//               c.player?.seekTo(value.toInt());
//               _currentPos = Duration(milliseconds: _seekPos.toInt());
//               mapsPosition =
//                   ((value.toInt() / duration.toInt()) * data.length).toInt();
//               // widget.data.setValue(_fijkViewPanelSeekto, _seekPos);
//               // _needClearSeekData = true;
//               _seekPos = -1.0;
//               currentValue = _seekPos > 0 ? _seekPos : dura2double(_currentPos);
//               currentValue = currentValue.clamp(0.0, duration);
//             });
//           }
//         }
//       },
//       onChanged: (value) {
//         _restartHideTimer();
//         setState(() {
//           _seekPos = value;
//         });
//       },
//     );
//
//     /*  return Padding(
//         padding: EdgeInsets.only(left: 3),
//         child: FijkSlider(
//           value: currentValue,
//           min: 0.0,
//           max: duration,
//           onChanged: (v) {
//             _restartHideTimer();
//             setState(() {
//               _seekPos = v;
//             });
//           },
//           onChangeEnd: (v) {
//             for (Channel c in listUrl) {
//               if (c.player != null && c.player!.state == FijkState.started) {
//                 setState(() {
//                   c.player?.seekTo(v.toInt());
//                   _currentPos = Duration(milliseconds: _seekPos.toInt());
//                   // widget.data.setValue(_fijkViewPanelSeekto, _seekPos);
//                   // _needClearSeekData = true;
//                   _seekPos = -1.0;
//                 });
//               }
//             }
//           },
//         ));*/
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
//             const ActionBarBack(title: "Server Playback"),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(left: 5),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   childAspectRatio: (1 / 1),
//                   controller: ScrollController(keepScrollOffset: false),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   children: listUrl.map((Channel value) {
//                     return Container(
//                       alignment: Alignment.center,
//                       margin: const EdgeInsets.only(right: 5, bottom: 5),
//                       // color: ColorCustom.greyBG,
//                       decoration: BoxDecoration(
//                           color: ColorCustom.greyBG,
//                           border: Border.all(
//                               color: value.select
//                                   ? Colors.green
//                                   : ColorCustom.greyBG)),
//                       child: value.channel != -1
//                           ? InkWell(
//                               onTap: () {
//                                 deselect();
//                                 value.select = true;
//                                 refresh();
//                               },
//                               child: Column(
//                                 children: [
//                                   Expanded(
//                                     child: Center(
//                                       child: FijkView(
//                                         color: Colors.black,
//                                         player: value.player!,
//                                         // panelBuilder: fijkPanel2BuilderCustom(
//                                         //     snapShot: true, onTick: (value) {}),
//                                         fsFit: FijkFit.fill,
//                                         // panelBuilder: simplestUI,
//                                         panelBuilder: (FijkPlayer player,
//                                             FijkData data,
//                                             BuildContext context,
//                                             Size viewSize,
//                                             Rect texturePos) {
//                                           // if (playerFirst == null &&
//                                           //     player.state == FijkState.started) {
//                                           //   playerFirst = player;
//                                           //   listenerTimer();
//                                           // }
//                                           // if (isSeek) {
//                                           //   data.setValue(
//                                           //       "__fijkview_panel_sekto_position",
//                                           //       sliderValue);
//                                           //   isSeek = false;
//                                           // }
//                                           return CustomFijkPanel(
//                                               player: player,
//                                               buildContext: context,
//                                               viewSize: viewSize,
//                                               texturePos: texturePos);
//                                         },
//                                       ),
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
//                             )
//                           : data.isNotEmpty
//                               ? Stack(
//                                   children: [
//                                     mapsWidget ?? Container(),
//                                     InkWell(
//                                       child: Container(),
//                                       onTap: () {
//                                         deselect();
//                                         value.select = true;
//                                         refresh();
//                                       },
//                                     )
//                                   ],
//                                 )
//                               : Container(),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             Container(
//               width: 500,
//               height: 200,
//               padding: const EdgeInsets.all(20),
//               color: ColorCustom.greyBG2,
//               child: Column(
//                 children: [
//                   // FlutterSlider(
//                   //   values: [0],
//                   //   max: 100,
//                   //   min: 0,
//                   //   rangeSlider: false,
//                   //   onDragging: (handlerIndex, lowerValue, upperValue) {
//                   //
//                   //   },
//                   // ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           children: [
//                             buildSlider(context),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     formatTime(int.parse(position)),
//                                     style: const TextStyle(
//                                         color: Colors.black, fontSize: 12),
//                                   ),
//                                 ),
//                                 Text(
//                                   formatTime(int.parse(duration)),
//                                   style: const TextStyle(
//                                       color: Colors.black, fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       InkWell(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: const EdgeInsets.all(10),
//                           child: const Icon(
//                             Icons.zoom_out_map,
//                             color: Colors.black,
//                           ),
//                         ),
//                         onTap: () {
//                           Channel? c = getSelect();
//                           if (c != null) {
//                             if (c.channel == -1) {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) =>
//                                           HomeBackupPlaybackVideoMaps(
//                                             listRoute: data,
//                                             vid: widget.cctvVehicle.vehicleId
//                                                 .toString(),
//                                             position: index,
//                                           )));
//                             } else {
//                               getSelect()?.player!.enterFullScreen();
//                             }
//
//                             // Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (_) => VideoPlayerViewFlk(
//                             //             url: getSelect()!.url!)));
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       InkWell(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: const EdgeInsets.all(10),
//                           child: const Icon(
//                             Icons.photo_camera,
//                             color: Colors.black,
//                           ),
//                         ),
//                         onTap: () {
//                           snapshot();
//                         },
//                       ),
//                       InkWell(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: const EdgeInsets.all(10),
//                           child: const Icon(
//                             Icons.fast_rewind,
//                             color: Colors.black,
//                           ),
//                         ),
//                         onTap: () {
//                           backPosition();
//                         },
//                       ),
//                       InkWell(
//                         onTap: () {
//                           if (isPlayAll) {
//                             stopAll();
//                           } else {
//                             playAll();
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: ColorCustom.primaryColor,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: const EdgeInsets.all(10),
//                           child: Icon(
//                             isPlayAll ? Icons.pause : Icons.play_arrow,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           nextPosition();
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: const EdgeInsets.all(10),
//                           child: const Icon(
//                             Icons.fast_forward,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: const EdgeInsets.all(10),
//                           child: const Icon(
//                             Icons.location_on,
//                             color: Colors.black,
//                           ),
//                         ),
//                         onTap: () {
//                           pinBtn();
//                         },
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
