import 'safety.dart';

import 'eco.dart';

class Dashboard {
  // List<DashboardData> data = [];
  List<Eco> eco = [];
  List<Safety> safety=[];

  int vehicle_count = 0;
  // var avgFuelCons;
  // double? mileage;
  // double? fuelUsed;
  // int? idleTime;
  // int? idleTimeHour;
  // int? idleTimeMinute;
  // double? idleFuelUsed;
  // int? idlingFuelCost;
  // int? overspedTime;
  // int? overspedTimeHour;
  // int? overspedTimeMinute;
  // int? overspdMax;
  // int? overspeedVehicleGroup;
  // int? dlt4hour;
  // int? dlt8hour;
  // int? dltOverspeed;
  // int? dltUnknown;
  // int? dltUnplug;
  // int? dltWrongtype;
  // int? harshStart;
  // int? harshAcc;
  // int? sharpTurn;
  // int? harshBrake;
  // int? over60;
  // int? over80;
  // int? over100;
  // int? over120;
  // int? checkLamp;
  // int? overMaintenancePeriod;
  // int? maintaninaceSoon;
  // int? batteryVoltageLow;
  // int? derateCondition;
  // int? tirePressureLow;


  Dashboard.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    //   data = [];
    //   json['data'].forEach((v) {
    //     data.add(new DashboardData.fromJson(v));
    //   });
    // }
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
    vehicle_count = json['vehicle_count'];
    // avgFuelCons = json['avg_fuel_cons'];
    // mileage = json['mileage'];
    // fuelUsed = json['fuel_used'];
    // idleTime = json['idle_time'];
    // idleTimeHour = json['idle_time_hour'];
    // idleTimeMinute = json['idle_time_minute'];
    // idleFuelUsed = json['idle_fuel_used'];
    // idlingFuelCost = json['idling_fuel_cost'];
    // overspedTime = json['oversped_time'];
    // overspedTimeHour = json['oversped_time_hour'];
    // overspedTimeMinute = json['oversped_time_minute'];
    // overspdMax = json['overspd_max'];
    // overspeedVehicleGroup = json['overspeed_vehicle_group'];
    // dlt4hour = json['dlt_4hour'];
    // dlt8hour = json['dlt_8hour'];
    // dltOverspeed = json['dlt_overspeed'];
    // dltUnknown = json['dlt_unknown'];
    // dltUnplug = json['dlt_unplug'];
    // dltWrongtype = json['dlt_wrongtype'];
    // harshStart = json['harsh_start'];
    // harshAcc = json['harsh_acc'];
    // sharpTurn = json['sharp_turn'];
    // harshBrake = json['harsh_brake'];
    // over60 = json['over_60'];
    // over80 = json['over_80'];
    // over100 = json['over_100'];
    // over120 = json['over_120'];
    // checkLamp = json['check_lamp'];
    // overMaintenancePeriod = json['over_maintenance_period'];
    // maintaninaceSoon = json['maintaninace_soon'];
    // batteryVoltageLow = json['battery_voltage_low'];
    // derateCondition = json['derate_condition'];
    // tirePressureLow = json['tire_pressure_low'];
  }
}