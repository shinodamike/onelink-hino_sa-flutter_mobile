
class Info {
  String? vin_no;
  int? vid;
  int? vehicle_id;
  String? licenseplate;
  String? licenseprov;
  String? vehicle_name;
  int? speed_limit;
  int? class_type;
  String? odo;
  String? model_code;
  String? box_phone;
  int? vehicle_type;
  String? geofence_name;

  Info.fromJson(Map<String, dynamic> json) {
    vin_no = json['vin_no'];
    vid = json['vid'];
    vehicle_id = json['vehicle_id'];
    licenseplate = json['licenseplate'];

    licenseprov = json['licenseprov'];
    vehicle_name = json['vehicle_name'];
    speed_limit = json['speed_limit'];
    class_type = json['class_type'];
     box_phone = json['box_phone'];
    vehicle_type = json['vehicle_type']??0;
    geofence_name = json['geofence_name']??"-";

    odo = json['odo'];
    if (odo == null || odo!.isEmpty) {
      odo = "0";
    }
    if (json.containsKey("model_code")) {
      model_code = json["model_code"];
    } else {
      model_code = "";
    }
    if (licenseplate!.isEmpty || licenseplate! == "-") {
      licenseplate = vin_no;
    }

    if (vehicle_name == null || vehicle_name!.isEmpty || vehicle_name! == "-") {
      vehicle_name = licenseplate;
    }
  }
}
