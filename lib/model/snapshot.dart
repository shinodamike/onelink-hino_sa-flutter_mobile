class SnapShot {
  int? channelNo;
  String? url;
  String? takePhotoTime;
  double? lat;
  double? lng;
  int? speed;
  String? location;

  SnapShot(
      {this.channelNo,
        this.url,
        this.takePhotoTime,
        this.lat,
        this.lng,
        this.speed,
        this.location});

  SnapShot.fromJson(Map<String, dynamic> json) {
    channelNo = json['channel_no'];
    url = json['url'];
    takePhotoTime = json['take_photo_time'];
    lat = json['lat'];
    lng = json['lng'];
    speed = json['speed'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel_no'] = channelNo;
    data['url'] = url;
    data['take_photo_time'] = takePhotoTime;
    data['lat'] = lat;
    data['lng'] = lng;
    data['speed'] = speed;
    data['location'] = location;
    return data;
  }
}