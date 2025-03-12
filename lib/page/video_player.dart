// import 'package:hino/widget/back_ios.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
//
//
// class VideoPlayerView extends StatefulWidget {
//   const VideoPlayerView({Key? key, required this.url}) : super(key: key);
//
//   final String url;
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoPlayerView> {
//   VideoPlayerController? _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     print(widget.url);
//     _controller = VideoPlayerController.network(widget.url)
//       ..initialize().then((value) => {
//
//        play()
//
//       });
//
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
//               child:  _controller!.value.isInitialized
//                   ? AspectRatio(
//                 aspectRatio: _controller!
//                     .value.aspectRatio,
//                 child: VideoPlayer(
//                     _controller!),
//               )
//                   : CircularProgressIndicator(),
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