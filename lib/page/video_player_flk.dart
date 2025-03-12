// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';
// import 'package:hino/widget/back_ios.dart';
//
// import '../widget/custom_ui.dart';
//
// class VideoPlayerViewFlk extends StatefulWidget {
//   const VideoPlayerViewFlk({Key? key, required this.url}) : super(key: key);
//
//   final String url;
//
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoPlayerViewFlk> {
//   FijkPlayer player = FijkPlayer();
//
//   @override
//   void initState() {
//     super.initState();
//     print(widget.url);
//     player = FijkPlayer();
//     player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
//     player.setOption(
//         FijkOption.playerCategory,
//         "mediacodec-all-videos"
//         "",
//         1);
//   }
//
//   play() async {
//     await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
//     await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
//     await player.setDataSource(widget.url, autoPlay: true).catchError((e) {
//       print("setDataSource error: $e");
//     });
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             BackIOS(),
//             Expanded(
//               child: FijkView(
//                 color: Colors.black,
//                 player: player,
//                 // panelBuilder: fijkPanel2Builder(snapShot: true),
//                 fsFit: FijkFit.fitWidth,
//                 panelBuilder: simplestUI,
//                 // panelBuilder: (FijkPlayer player, BuildContext context,
//                 //     Size viewSize, Rect texturePos) {
//                 //   return CustomFijkPanel(
//                 //       player: player,
//                 //       buildContext: context,
//                 //       viewSize: viewSize,
//                 //       texturePos: texturePos);
//                 // },
//               ),
//             )
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     setState(() {
//       //       _controller!.value.isPlaying
//       //           ? _controller!.pause()
//       //           : _controller!.play();
//       //     });
//       //   },
//       //   child: Icon(
//       //     _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//       //   ),
//       // ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     player.release();
//   }
// }
