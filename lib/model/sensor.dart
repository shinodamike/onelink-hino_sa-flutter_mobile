
import 'package:iov/model/canbus.dart';
import 'package:iov/model/option.dart';
import 'package:iov/model/temperature.dart';

class Sensor {
  Option? option;

  Temperature? temperature;

  Canbus? canbus;

  Sensor.fromJson(Map<String, dynamic> json) {
    option = Option.fromJson(json['options']);
    temperature = Temperature.fromJson(json['temperatures']);
    canbus = Canbus.fromJson(json["canbus"]);
  }
}
