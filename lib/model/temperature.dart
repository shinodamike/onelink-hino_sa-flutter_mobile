
class Temperature {


  String? sensor1 ;
  String? sensor2 ;
  String? sensor3 ;
  String? sensor4 ;


  Temperature.fromJson(Map<String, dynamic> json) {
    sensor1 = json['sensor1'];
    sensor2 = json['sensor2'];
    sensor3 = json['sensor3'];
    sensor4 = json['sensor4'];

  }
}

