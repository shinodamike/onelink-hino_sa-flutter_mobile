// import 'dart:ffi';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hino/model/cctv_vehicle.dart';
// import 'package:hino/page/video_player.dart';
// import 'package:hino/page/video_player_vlc.dart';
// import 'package:hino/utils/color_custom.dart';
// import 'package:hino/widget/actionbar_back.dart';
// import 'package:video_player/video_player.dart';
//
// import '../api/api.dart';
// import '../model/cctv_date_channel.dart';
// import '../model/channel.dart';
//
// class HomeBackupPlaybackVideoPage extends StatefulWidget {
//   const HomeBackupPlaybackVideoPage(
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
//   // case the title) provided by the parent (in this case the App widget) and
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
// class _PageState extends State<HomeBackupPlaybackVideoPage> {
//   List<double> playbackSpeeds = [0.5, 1.0, 2.0];
//   int playbackSpeedIndex = 1;
//   final double initSnapshotRightPosition = 10;
//   final double initSnapshotBottomPosition = 10;
//
//   @override
//   void initState() {
//     getLive(context);
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
//           context,
//           Api.cctv_live +
//               Api.profile!.userId.toString() +
//               "&vehicle_id=" +
//               widget.cctvVehicle.vehicleId.toString() +
//               "&channel=" +
//               c.channel_id.toString() +
//               "&start=" +
//               widget.start +
//               "&end=" +
//               widget.end +
//               "&ft=0&st=" +
//               widget.device)
//           .then((value) => {
//         if (value != null)
//           {
//             count++,
//             for (var res in value["result"])
//               {
//                 listUrl.add(
//                     Channel(c.label_name!, c.channel_id!, res["url"]))
//               },
//             if (count == widget.listChannel.length) {initAll()}
//           }
//         else
//           {}
//       });
//     }
//   }
//
//   bool isPlayAll = true;
//
//   initAll() {
//     isPlayAll = true;
//     for (Channel c in listUrl) {
//       c.select = false;
//       print(c.url!);
//       if (c.url != null) {
//         c.controller = VideoPlayerController.network(c.url!,
//             videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
//           ..initialize().then((value) => {c.controller!.play(), refresh()});
//
//         // c.controllerVlc = VlcPlayerController.network(
//         //   c.url!,
//         //   hwAcc: HwAcc.auto,
//         //   autoPlay: true,
//         //   autoInitialize: true,
//         //   options: VlcPlayerOptions(),
//         // );
//         //
//         // c.controllerVlc?.addListener(listener);
//       }
//     }
//     refresh();
//   }
//
//   int max = 100;
//   int sliderValue = 0;
//   String position = '';
//   String duration = '';
//   bool validPosition = false;
//   VideoPlayerController? _controller;
//
//   void listener() async {
//     if (!mounted) return;
//     //
//     _controller = getPlayVideo()?.controller;
//     if (_controller != null && _controller!.value.isInitialized) {
//       max = _controller!.value.duration.inSeconds;
//       var oPosition = _controller!.value.position;
//       var oDuration = _controller!.value.duration;
//       // sliderValue = oPosition.inSeconds;
//       // print(oPosition.inSeconds);
//
//       if (oPosition != null && oDuration != null) {
//         if (oDuration.inHours == 0) {
//           var strPosition = oPosition.toString().split('.')[0];
//           var strDuration = oDuration.toString().split('.')[0];
//           position =
//               "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
//           duration =
//               "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
//         } else {
//           position = oPosition.toString().split('.')[0];
//           duration = oDuration.toString().split('.')[0];
//         }
//         validPosition = oDuration.compareTo(oPosition) >= 0;
//         sliderValue = validPosition ? oPosition.inSeconds : 0;
//       }
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
//       c.controller!.play();
//     }
//     refresh();
//   }
//
//   stopAll() {
//     isPlayAll = false;
//     for (Channel c in listUrl) {
//       // c.select = false;
//       c.controller!.pause();
//     }
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
//       if (c.controller!.value.isPlaying) {
//         return c;
//       }
//     }
//     return null;
//   }
//
//   nextPosition() async {
//     isPlayAll = true;
//     for (Channel c in listUrl) {
//       if (c.controller != null && c.controller!.value.isPlaying) {
//         await c.controller!
//             .seekTo(c.controller!.value.position + Duration(seconds: 10));
//       }
//     }
//   }
//
//   backPosition() async {
//     isPlayAll = true;
//     for (Channel c in listUrl) {
//       if (c.controller != null && c.controller!.value.isPlaying) {
//         await c.controller!
//             .seekTo(c.controller!.value.position + Duration(seconds: -10));
//       }
//     }
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     for (Channel c in listUrl) {
//       c.controller!.dispose();
//     }
//   }
//
//   void _cyclePlaybackSpeed() async {
//     playbackSpeedIndex++;
//     if (playbackSpeedIndex >= playbackSpeeds.length) {
//       playbackSpeedIndex = 0;
//     }
//     for (Channel c in listUrl) {
//       await c.controller!
//           .setPlaybackSpeed(playbackSpeeds.elementAt(playbackSpeedIndex));
//     }
//   }
//
//   var seekIndex = 0;
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
//             ActionBarBack(title: "Server Playback"),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(left: 5),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   childAspectRatio: (1 / 1),
//                   controller: new ScrollController(keepScrollOffset: false),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   children: listUrl.map((Channel value) {
//                     return Container(
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.only(right: 5, bottom: 5),
//                       // color: ColorCustom.greyBG,
//                       decoration: BoxDecoration(
//                           color: ColorCustom.greyBG,
//                           border: Border.all(
//                               color: value.select
//                                   ? Colors.blue
//                                   : ColorCustom.greyBG)),
//                       child: InkWell(
//                         onTap: () {
//                           deselect();
//                           value.select = true;
//                           refresh();
//                         },
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: Center(
//                                 child: value.controller!.value.isInitialized
//                                     ? AspectRatio(
//                                         aspectRatio:
//                                             value.controller!.value.aspectRatio,
//                                         child: VideoPlayer(value.controller!),
//                                       )
//                                     : CircularProgressIndicator(),
//                               ),
//                             ),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.videocam),
//                                 Text(
//                                   value.labelName!,
//                                   style: TextStyle(
//                                     color: ColorCustom.black,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
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
//                             Slider(
//                               min: 0.0,
//                               max: max.toDouble(),
//                               value: sliderValue.toDouble(),
//                               // interval: 1,
//                               // showTicks: false,
//                               // showLabels: false,
//                               // enableTooltip: false,
//                               // minorTicksPerInterval: 1,
//                               onChanged: (value) {
//                                 print(value.toString());
//                                 print("MAX   " + max.toString());
//                                 var duration =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         value.toInt() * 1000);
//                                 print("date   " + duration.toString());
//                                 sliderValue = value.floor();
//                                 // for (Channel c in listUrl) {
//                                 //   if (c.controller != null && c.controller!.value.isPlaying) {
//                                 //     c.controller!.setTime(sliderValue
//                                 //         *1000);
//                                 //   }
//                                 // }
//                                 refresh();
//                               },
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     position,
//                                     style: TextStyle(
//                                         color: Colors.black, fontSize: 12),
//                                   ),
//                                 ),
//                                 Text(
//                                   duration,
//                                   style: TextStyle(
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
//                           padding: EdgeInsets.all(10),
//                           child: Icon(
//                             Icons.zoom_out_map,
//                             color: Colors.black,
//                           ),
//                         ),
//                         onTap: () {
//                           if (getSelect() != null) {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => VideoPlayerView(
//                                         url: getSelect()!.url!)));
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(100),
//                             border: Border.all(width: 1, color: Colors.grey)),
//                         padding: EdgeInsets.all(10),
//                         child: Icon(
//                           Icons.photo_camera,
//                           color: Colors.black,
//                         ),
//                       ),
//                       InkWell(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: EdgeInsets.all(10),
//                           child: Icon(
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
//                               color: ColorCustom.blue,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(width: 1, color: Colors.grey)),
//                           padding: EdgeInsets.all(10),
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
//                           padding: EdgeInsets.all(10),
//                           child: Icon(
//                             Icons.fast_forward,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(100),
//                             border: Border.all(width: 1, color: Colors.grey)),
//                         padding: EdgeInsets.all(10),
//                         child: Icon(
//                           Icons.location_on,
//                           color: Colors.black,
//                         ),
//                       ),
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
