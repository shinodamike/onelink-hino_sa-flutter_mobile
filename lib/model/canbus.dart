
class Canbus {


  int? accPedal;
  String? clutchSwitch;
  int? cooltemp;
  String? dtcEngine;
  String? exhaustBrake;
  String? footBrake;
  int? fuelPer;
  String? fuelRate;
  int? rpm;


  Canbus.fromJson(Map<String, dynamic> json) {
    accPedal = json['acc_pedal']?.toInt();
    clutchSwitch = json['clutch_switch'];
    cooltemp = json['cooltemp']?.toInt();
    dtcEngine = json['dtc_engine'];
    exhaustBrake = json['exhaust_brake'];
    footBrake = json['foot_brake'];
    fuelPer = json['fuel_per']?.toInt();
    fuelRate = json['fuel_rate'];
    rpm = json['rpm']?.toInt();
  }
}









