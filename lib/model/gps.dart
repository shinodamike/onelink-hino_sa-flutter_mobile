
import 'package:iov/model/location.dart';

class Gps {

  String? imei;
  String? gpsdate;
  String? server_date;
  double? lat;
  double? lng;
  var speed;
  String? io_code;
  String? io_name;
  String? io_color;
  String? acc;
  String? gps_stat;
  double? course;
  int? sattellite;
  int? sattellite_per;
  int? sattellite_level;
  int? gsm;
  int? gsm_per;
  int? gsm_level;
  double? device_batt;
  double? vehicle_batt;
  int? device_batt_level;
  int? vehicle_batt_level;
  String? fuel_rate;
  int? fuel_cons;
  int? fuel_per;
  Location? location;
  String? display_gpsdate;


  Gps.fromJson(Map<String, dynamic> json) {
    imei = json['imei'];
    gpsdate = json['gpsdate'];
    server_date = json['server_date'];
    lat = json['lat'];
    lng = json['lng'];
    speed = json['speed'];
    io_code = json['io_code'];
    io_name = json['io_name'];
    io_color = json['io_color'];
    acc = json['acc'];
    gps_stat = json['gps_stat'];
    course = json['course'];
    sattellite = json['sattellite'];
    sattellite_per= json['sattellite_per'];
    sattellite_level= json['sattellite_level'];
    gsm= json['gsm'];
    gsm_per= json['gsm_per'];
    gsm_level= json['gsm_level'];
    device_batt= json['device_batt'];
    vehicle_batt= json['vehicle_batt'];
    device_batt_level= json['device_batt_level'];
    vehicle_batt_level= json['vehicle_batt_level'];
    fuel_rate= json['fuel_rate'];
    fuel_cons= json['fuel_cons'];
    fuel_per= json['fuel_per'];
    display_gpsdate= json['display_gpsdate'];
    location = Location.fromJson(json['location']);
  }
}
