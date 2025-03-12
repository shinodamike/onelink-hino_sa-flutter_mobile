
class Fleet {


  int? fleet_id ;
  String? fleet_name ;


  Fleet.fromJson(Map<String, dynamic> json) {
    fleet_id = json['fleet_id'];
    fleet_name = json['fleet_name'];

  }
}

