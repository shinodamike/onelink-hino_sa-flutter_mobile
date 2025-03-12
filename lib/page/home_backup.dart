
import 'package:flutter/material.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/page/home_backup_event.dart';
import 'package:iov/utils/color_custom.dart';



import 'home_backup_playback.dart';

class HomeBackupPage extends StatefulWidget {
  const HomeBackupPage({Key? key}) : super(key: key);

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

class _PageState extends State<HomeBackupPage> {
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
      resizeToAvoidBottomInset: false,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeBackupEventPage()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.grey),
                    shape: const StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(Languages.of(context)!.tracking_history,
                      style: const TextStyle(
                        color: ColorCustom.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )),
            // Container(
            //     padding: const EdgeInsets.all(10),
            //     width: double.infinity,
            //     child: OutlinedButton(
            //       onPressed: (){
            //         Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => const HomeBackupPlaybackPage()));
            //       },
            //       style: OutlinedButton.styleFrom(
            //         side: const BorderSide(width: 1.0, color: Colors.grey),
            //         backgroundColor: ColorCustom.white,
            //         shape: const StadiumBorder(),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(10),
            //         child: Text(Languages.of(context)!.cctv_playback,
            //           style: const TextStyle(
            //             color: ColorCustom.black,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ),
            //     )),
            // Container(
            //     margin: EdgeInsets.all(10),
            //     width: double.infinity,
            //     child: OutlinedButton(
            //       onPressed: (){
            //         Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => HomeBackupSnapshotPage()));
            //       },
            //       child: Padding(
            //         child: Text(Languages.of(context)!.camera_playback,
            //           style: TextStyle(
            //             color: ColorCustom.black,
            //             fontSize: 16,
            //           ),
            //         ),
            //         padding: EdgeInsets.all(10),
            //       ),
            //       style: OutlinedButton.styleFrom(
            //         side: BorderSide(width: 1.0, color: Colors.grey),
            //         backgroundColor: ColorCustom.white,
            //         shape: StadiumBorder(),
            //       ),
            //
            //     )),
          ],
        ),
      ),
    );
  }
}
