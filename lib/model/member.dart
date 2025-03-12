
class Member {


  String? vehicle_name ;
  String? my_onlynumbers ;
  String? my_numbers_withalphebet ;
  String? my_utf8 ;
  String? vin_no ;
  int? int_vehicle_id ;
  int? int_cust_id ;
  int? fleet_id ;
  String? fleet_name ;
  String? chassis_no ;
  String? license_plate_no ;
  String? mid ;
  String? imei ;



  Member.fromJson(Map<String, dynamic> json) {
    vehicle_name = json['vehicle_name'];
    my_onlynumbers = json['my_onlynumbers'];
    my_numbers_withalphebet = json['my_numbers_withalphebet'];
    my_utf8 = json['my_utf8'];
    vin_no = json['vin_no'];
    int_vehicle_id = json['int_vehicle_id'];
    int_cust_id = json['int_cust_id'];
    fleet_id = json['fleet_id'];
    fleet_name = json['fleet_name'];
    chassis_no= json['chassis_no'];
    license_plate_no= json['license_plate_no'];
    mid= json['mid'];
    imei= json['imei'];
    if (license_plate_no==null||license_plate_no!.isEmpty) {
      license_plate_no = vehicle_name;
    }
    if (license_plate_no==null||license_plate_no!.isEmpty) {
      license_plate_no = vin_no;
    }
  }
}

