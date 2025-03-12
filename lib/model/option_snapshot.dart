

class OptionSnapshot {

  int? channel_no;
  String? take_photo_time;
  String? url;


  OptionSnapshot.fromJson(Map<String, dynamic> json) {
    take_photo_time = json['take_photo_time'];
    channel_no = json['channel_no'];
    url = json['url'];
  }
}

