
// import 'package:fijkplayer/fijkplayer.dart';

class Channel {
  int? channel;
  String? labelName;
  String? url;
  // VlcPlayerController? controllerVlc;
  // FijkPlayer? player;
  // VideoPlayerController? controller;
  bool select = true;
  bool selectFullScreen = false;

  Channel(String name,int a,String url) {
    labelName = name;
    channel = a;
    this.url = url;
  }

  Channel.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    labelName = json['label_name'];
    url = json['url'];
    // if (url != null) {
    //   controller = VideoPlayerController.network(url!,videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
    //     ..initialize().then((value) => {
    //       controller!.play()
    //     });
    // }
  }
}
