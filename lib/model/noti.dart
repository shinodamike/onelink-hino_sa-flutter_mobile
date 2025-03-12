
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/language_en.dart';
import 'package:iov/localization/language/language_jp.dart';
import 'package:iov/localization/language/language_th.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/utils/utils.dart';

class Noti {
  String? unix;

  int? event_id;

  String? license;

  String? vehicle_name;

  String? driver_name;

  String? vin_no;

  int? condition_val;

  String? gpsdate;

  String? acc;

  double? lat;

  double? lng;

  var course;

  int? speed;

  int? mileage;

  String? location;

  String? card_id;

  Vehicle? vehicle;
  String? display_gpsdate;

  Noti.fromJson(Map<String, dynamic> json) {
    unix = json['unix'];
    event_id = json['event_id'];
    license = json['license'];
    vehicle_name = json['vehicle_name'];
    driver_name = json['driver_name'];
    vin_no = json['vin_no'];
    condition_val = json['condition_val'];
    gpsdate = json['gpsdate'];
    acc = json['acc'];
    lat = json['lat'];
    lng = json['lng'];
    course = json['course'];
    speed = json['speed'];
    mileage = json['mileage'];
    location = json['location'];
    display_gpsdate = json['display_gpsdate'];
    vehicle = Utils.getVehicleByVinNo(vin_no!);

    if (license == null || license!.isEmpty || license! == "-") {
      license = vin_no;
    }

    if (vehicle_name == null || vehicle_name!.isEmpty || vehicle_name! == "-") {
      vehicle_name = license;
    }

    card_id = json['card_id'] ?? "";
    if (driver_name == null || driver_name!.isEmpty) {
      driver_name = card_id;
    }

    if (driver_name == null || driver_name!.isEmpty || driver_name == "-") {
      // driver_name = "ไม่ระบุผู้ขับขี่";

      if (Api.language == "th") {
        driver_name = LanguageTh().unidentified_driver;
      } else if (Api.language == "ja") {
        driver_name = LanguageJp().unidentified_driver;
      } else {
        driver_name = LanguageEn().unidentified_driver;
      }
    }
  }
}
