// import 'dart:math';
//
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:iov/utils/color_custom.dart';
//
// /// https://fijkplayer.befovy.com/docs/zh/custom-ui.html#%E6%97%A0%E7%8A%B6%E6%80%81-ui-
// Widget simplestUI(FijkPlayer player, FijkData data, BuildContext context,
//     Size viewSize, Rect texturePos) {
//   Rect rect = Rect.fromLTRB(
//       max(0.0, texturePos.left),
//       max(0.0, texturePos.top),
//       min(viewSize.width, texturePos.right),
//       min(viewSize.height, texturePos.bottom));
//   bool isPlaying = player.state == FijkState.started;
//   bool isError = player.state == FijkState.error;
//   bool isPaused = player.state == FijkState.paused;
//
//   return Positioned.fromRect(
//     rect: rect,
//     child: Container(
//         alignment: Alignment.bottomLeft,
//         // child: IconButton(
//         //   icon: Icon(
//         //     isPlaying ? Icons.pause : Icons.play_arrow,
//         //     color: Colors.white,
//         //   ),
//         //   onPressed: () {
//         //     isPlaying ? player.pause() : player.start();
//         //   },
//         // ),
//         child: videoPlaceHolder(player.state)),
//   );
// }
//
//
// Widget videoPlaceHolder(FijkState state) {
//   print("FijkState ${state.name}");
//   if (state == FijkState.error) {
//     return const Center(
//       child: Text(
//         "Video loss",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//       ),
//     );
//   } else if (state == FijkState.paused) {
//     return const Center(
//       child: Text(
//         "Pause",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//       ),
//     );
//   } else if (state == FijkState.prepared) {
//     return const Center(
//         child: Center(
//       child: Text(
//         "Ready",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//       ),
//     ));
//   }
//   else if (state == FijkState.asyncPreparing) {
//     return const Center(child: CircularProgressIndicator(color: ColorCustom.primaryColor));
//   }
//   else if (state == FijkState.initialized&&isFirst) {
//     isFirst = false;
//     return const Center(child: CircularProgressIndicator(color: ColorCustom.primaryColor));
//   }
//   else {
//     return Container();
//   }
// }
//
// bool isFirst = true;
// /// https://fijkplayer.befovy.com/docs/zh/custom-ui.html#%E6%9C%89%E7%8A%B6%E6%80%81-ui
// class CustomFijkPanel extends StatefulWidget {
//   final FijkPlayer player;
//   final BuildContext buildContext;
//   final Size viewSize;
//   final Rect texturePos;
//
//   const CustomFijkPanel({super.key,
//     required this.player,
//     required this.buildContext,
//     required this.viewSize,
//     required this.texturePos,
//   });
//
//   @override
//   _CustomFijkPanelState createState() => _CustomFijkPanelState();
// }
//
// class _CustomFijkPanelState extends State<CustomFijkPanel> {
//   FijkPlayer get player => widget.player;
//   FijkState _playing = FijkState.initialized;
//
//   @override
//   void initState() {
//     isFirst = true;
//     super.initState();
//     widget.player.addListener(_playerValueChanged);
//   }
//
//   void _playerValueChanged() {
//     FijkValue value = player.value;
//     print(DateFormat('HHmm').format(
//         DateTime.fromMillisecondsSinceEpoch(player.currentPos.inMilliseconds)));
//     setState(() {
//       _playing = value.state;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Rect rect = Rect.fromLTRB(
//         max(0.0, widget.texturePos.left),
//         max(0.0, widget.texturePos.top),
//         min(widget.viewSize.width, widget.texturePos.right),
//         min(widget.viewSize.height, widget.texturePos.bottom));
//
//     return Positioned.fromRect(
//       rect: rect,
//       child: Container(
//           alignment: Alignment.bottomLeft,
//           child: Stack(
//             children: [
//               videoPlaceHolder(_playing),
//               player.value.fullScreen?IconButton(
//                 padding: const EdgeInsets.only(left: 5),
//                 icon: const Icon(
//                   Icons.arrow_back_ios,
//                   color: Color(0xDDFFFFFF),
//                 ),
//                 onPressed: (){
//                   Navigator.pop(context);
//                   // setState(() {
//                   //   player.exitFullScreen();
//                   // });
//
//                 },
//               ):Container(),
//             ],
//           )),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     player.removeListener(_playerValueChanged);
//   }
// }
