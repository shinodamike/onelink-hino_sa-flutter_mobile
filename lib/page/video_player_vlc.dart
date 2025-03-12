// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:hino/widget/back_ios.dart';
// import 'package:flutter/material.dart';
//
//
// class VideoPlayerVlcView extends StatefulWidget {
//   const VideoPlayerVlcView({Key? key, required this.url}) : super(key: key);
//
//   final String url;
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoPlayerVlcView> {
//   VlcPlayerController? _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     print(widget.url);
//     // _controller = VideoPlayerController.network(widget.url)
//     //   ..initialize().then((value) => {
//     //
//     //    play()
//     //
//     //   });
//     _controller = VlcPlayerController.network(widget.url,
//       hwAcc: HwAcc.auto,
//       autoPlay: true,
//       autoInitialize: true,
//       options: VlcPlayerOptions(),
//     );
//   }
//   play(){
//     _controller!.play();
//     setState(() {
//
//     });
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
//             Center(
//               child: AspectRatio(
//                 aspectRatio: _controller!.value.aspectRatio,
//                 child: VlcPlayer(
//                     controller: _controller!,
//                     aspectRatio: 16 / 9,placeholder:
//                 Center(child: CircularProgressIndicator())),
//               )
//             ),
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
//     _controller!.dispose();
//   }
// }