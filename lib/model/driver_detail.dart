
import 'package:iov/model/Eco.dart';
import 'package:iov/model/safety.dart';

class DriverDetail {


  String? driver_name ;
  String? driver_license_id ;
  String? driver_licensecard_type ;
  String? card_expire ;
  String? total_time ;
  double? distance ;
  double? fuel_usage ;
  List<Safety> safety = [];
  List<Eco> eco = [];

  DriverDetail.fromJson(Map<String, dynamic> json) {
    driver_name = json['driver_name'];
    driver_license_id = json['driver_license_id'];
    driver_licensecard_type = json['driver_licensecard_type'];
    card_expire = json['card_expire'];
    total_time = json['total_time'];
    distance = json['distance'];
    fuel_usage = json['fuel_usage'];
    safety = List.from(json['safety'])
        .map((a) => Safety.fromJson(a))
        .toList();
    eco = List.from(json['eco'])
        .map((a) => Eco.fromJson(a))
        .toList();
  }
}

