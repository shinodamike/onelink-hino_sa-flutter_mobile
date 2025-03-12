

class ChannelCheck {
  int? chn;
  int? filetype;
  String? name;
  String? starttime;
  String? endtime;


  ChannelCheck.fromJson(Map<String, dynamic> json) {
    chn = json['chn'];
    filetype = json['filetype'];
    name = json['name'];
    starttime = json['starttime'];
    endtime = json['endtime'];
  }
}
