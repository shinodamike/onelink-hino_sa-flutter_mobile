

class CctvDateChannel {

  String? label_name;
  int? channel_id;

  CctvDateChannel(String name,int a) {
    label_name = name;
    channel_id = a;
  }

  CctvDateChannel.fromJson(Map<String, dynamic> json) {

    label_name = json['label_name'];
    channel_id = json['channel_id'];
  }
}
