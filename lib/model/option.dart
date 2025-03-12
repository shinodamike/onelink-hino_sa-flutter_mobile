
class Option {


  String? pto ;
  String? door_sensor ;
  String? safety_belt ;


  Option.fromJson(Map<String, dynamic> json) {
    door_sensor = json['door_sensor'];
    pto = json['pto'];
    safety_belt= json['safety_belt'];
  }
}

