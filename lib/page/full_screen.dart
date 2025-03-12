// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
//
// void pushFullScreenVideo(BuildContext context) {
//   bool isPortrait = true;
// //This will help to hide the status bar and bottom bar of Mobile
// //also helps you to set preferred device orientations like landscape
//
//   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
//   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//   SystemChrome.setPreferredOrientations(
//     [
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ],
//   );
//
// //This will help you to push fullscreen view of video player on top of current page
//
//   Navigator.of(context)
//       .push(
//     PageRouteBuilder(
//       opaque: false,
//       settings: RouteSettings(),
//       pageBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//       ) {
//         return Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Dismissible(
//                 key: const Key('key'),
//                 direction: DismissDirection.vertical,
//                 onDismissed: (_) => Navigator.of(context).pop(),
//                 child: OrientationBuilder(
//                   builder: (context, orientation) {
//                     isPortrait = orientation == Orientation.portrait;
//                     return Center(
//                       child: Stack(
//                         //This will help to expand video in Horizontal mode till last pixel of screen
//                         fit: isPortrait ? StackFit.loose : StackFit.expand,
//                         children: [
//                           AspectRatio(
//                             aspectRatio: controller.value.aspectRatio,
//                             child: VideoPlayer(controller),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 )));
//       },
//     ),
//   )
//       .then(
//     (value) {
// //This will help you to set previous Device orientations of screen so App will continue for portrait mode
//
//       SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//       SystemChrome.setPreferredOrientations(
//         [
//           DeviceOrientation.portraitUp,
//           DeviceOrientation.portraitDown,
//         ],
//       );
//     },
//   );
// }
