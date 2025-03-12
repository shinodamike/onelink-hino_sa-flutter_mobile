
import 'package:flutter/material.dart';




class HomeBackupEventSearchVideoPage extends StatefulWidget {
  const HomeBackupEventSearchVideoPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeBackupEventSearchVideoPage> {
  @override
  void initState() {
    // videoPlayerController.initialize();
    // chewieController = ChewieController(
    //   aspectRatio: videoPlayerController.value.aspectRatio,
    //   videoPlayerController: videoPlayerController,
    //   autoPlay: true,
    //   looping: false,
    // );
    // playerWidget = Chewie(
    //   controller: chewieController!,
    // );
    super.initState();
  }

  // final videoPlayerController = VideoPlayerController.network(
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
  //
  // ChewieController? chewieController;
  //
  // Chewie? playerWidget;

  // @override
  // void dispose() {
  //   videoPlayerController.dispose();
  //   chewieController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Video"),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Center(
          // child: playerWidget,
        ),
      ),
    );
  }
}
