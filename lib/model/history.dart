
import 'package:iov/model/location.dart';

class History {

  String? gpsdate;
  double? lat;
  double? lng;
  String? server_date;
  double? speed;
  double? mileage;
  String? acc;
  Location? location;

  History.fromJson(Map<String, dynamic> json) {
    gpsdate = json['gpsdate'];
    lat = json['lat'];
    lng = json['lng'];
    server_date = json['server_date'];
    speed = json['speed'];
    mileage = json['mileage'];
    acc = json['acc'];
    location = Location.fromJson(json["location"]);
  }
}
