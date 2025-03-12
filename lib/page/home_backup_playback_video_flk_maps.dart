import 'package:flutter/material.dart';
import 'package:iov/widget/actionbar_back.dart';
import 'package:iov/widget/map_playback.dart';

class HomeBackupPlaybackVideoMaps extends StatefulWidget {
  const HomeBackupPlaybackVideoMaps({
    Key? key,
    required this.listRoute,
    required this.vid,
    this.position,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final List listRoute;
  final String vid;

  final int? position;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeBackupPlaybackVideoMaps> {
  @override
  void initState() {
    super.initState();
  }

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
      body: SafeArea(
        child: Column(
          children: [
            const ActionBarBack(title: "Server Playback"),
            Expanded(
              child: MapPlaybackWidget(
                  vid: widget.vid,
                  listRoute: widget.listRoute,
                  position: widget.position),
            ),
          ],
        ),
      ),
    );
  }
}
