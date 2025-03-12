import 'package:iov/model/safety.dart';

import 'eco.dart';

class DashboardData {
  String? datetime;
  String? display_datetime;

  int? driv;
  int? idle;
  int? park;
  int? overspd;
  int? offline;
  int? overspdMax;
  int? overspedCount;
  int? overspedTime;
  int? overspedTimeHour;
  int? overspedTimeMinute;
  // int? drivingTime;
  // int? idleTime;
  int? idleTimeHour;
  int? idleTimeMinute;
  // int? parkingTime;
  int? idleMax;
  double? idleFuelUsed;
  double? mileage;
  int? idlingFuelCost;
  var avgFuelCons;
  double? fuelUsed;
  var fuelCons;
  int? overspeed;
  int? dltOverspeed;
  int? dlt4hour;
  int? dlt8hour;
  int? dltUnknown;
  int? dltWrongtype;
  int? dltUnplug;
  int? harshStart;
  int? harshAcc;
  int? harshBrake;
  int? sharpTurn;
  int? over60;
  int? over80;
  int? over100;
  int? over120;
  int? checkLamp;
  int? overMaintenancePeriod;
  int? maintaninaceSoon;
  int? batteryVoltageLow;
  int? derateCondition;
  int? tirePressureLow;
  List<Eco> eco = [];
  List<Safety> safety=[];


  DashboardData.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    display_datetime = json['display_datetime'];
    driv = json['driv'];
    idle = json['idle'];
    park = json['park'];
    overspd = json['overspd'];
    offline = json['offline'];
    overspdMax = json['overspd_max'];
    overspedCount = json['oversped_count'];
    overspedTime = json['oversped_time'];
    overspedTimeHour = json['oversped_time_hour'];
    overspedTimeMinute = json['oversped_time_minute'];
    // drivingTime = json['driving_time'];
    // idleTime = json['idle_time'];
    idleTimeHour = json['idle_time_hour'];
    idleTimeMinute = json['idle_time_minute'];
    // parkingTime = json['parking_time'];
    idleMax = json['idle_max'];
    idleFuelUsed = json['idle_fuel_used'];
    mileage = json['mileage'];
    idlingFuelCost = json['idling_fuel_cost'];
    avgFuelCons = json['avg_fuel_cons'];
    fuelUsed = json['fuel_used'];
    fuelCons = json['fuel_cons'];
    overspeed = json['overspeed'];
    dltOverspeed = json['dlt_overspeed'];
    dlt4hour = json['dlt_4hour'];
    dlt8hour = json['dlt_8hour'];
    dltUnknown = json['dlt_unknown'];
    dltWrongtype = json['dlt_wrongtype'];
    dltUnplug = json['dlt_unplug'];
    harshStart = json['harsh_start'];
    harshAcc = json['harsh_acc'];
    harshBrake = json['harsh_brake'];
    sharpTurn = json['sharp_turn'];
    over60 = json['over_60'];
    over80 = json['over_80'];
    over100 = json['over_100'];
    over120 = json['over_120'];
    checkLamp = json['check_lamp'];
    overMaintenancePeriod = json['over_maintenance_period'];
    maintaninaceSoon = json['maintaninace_soon'];
    batteryVoltageLow = json['battery_voltage_low'];
    derateCondition = json['derate_condition'];
    tirePressureLow = json['tire_pressure_low'];
    if (json['eco'] != null) {
      eco = [];
      json['eco'].forEach((v) {
        eco.add(Eco.fromJson(v));
      });
    }
    if (json['safety'] != null) {
      safety = [];
      json['safety'].forEach((v) {
        safety.add(Safety.fromJson(v));
      });
    }
  }
}