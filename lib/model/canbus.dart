
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
    accPedal = json['acc_pedal'];
    clutchSwitch = json['clutch_switch'];
    cooltemp = json['cooltemp'];
    dtcEngine = json['dtc_engine'];
    exhaustBrake = json['exhaust_brake'];
    footBrake = json['foot_brake'];
    fuelPer = json['fuel_per'];
    fuelRate = json['fuel_rate'];
    rpm = json['rpm'];

  }
}









