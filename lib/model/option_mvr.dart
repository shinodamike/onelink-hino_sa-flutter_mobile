

import 'channel.dart';

class OptionMvr {

  bool? audio;
  int? cameraUnit;
  List<Channel>? channel;
  bool? mainStream;
  bool? subStream;
  String? terminalNumber;


  OptionMvr.fromJson(Map<String, dynamic> json) {
    audio = json['audio'];
    cameraUnit = json['camera_unit'];
    if (json['channel'] != null) {
      channel = [];
      json['channel'].forEach((v) {
        channel?.add(Channel.fromJson(v));
      });
      channel?.sort((a, b) => a.channel!.compareTo(b.channel!));
    }else{
      channel = [];
    }
    mainStream = json['main_stream'];
    subStream = json['sub_stream'];
    terminalNumber = json['terminal_number'];
  }
}

