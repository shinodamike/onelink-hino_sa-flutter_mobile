
import 'package:iov/model/Sensor.dart';
import 'package:iov/model/behavior.dart';
import 'package:iov/model/info.dart';
import 'package:iov/model/maintenance.dart';
import 'package:iov/model/option_mvr.dart';
import 'package:iov/model/option_snapshot.dart';

import 'gps.dart';

class VehicleDetail {
  Maintenance? maintenance;
  Sensor? sensor;
  OptionMvr? optionMvr;
  List<OptionSnapshot> optionSnapshots = [];
  Info? info;

  Gps? gps;

  List<Behavior> listBehavior = [];
  List<Behavior> listDlt = [];

  VehicleDetail.fromJson(Map<String, dynamic> json) {
    info = Info.fromJson(json['info']);
    gps = Gps.fromJson(json['gps']);

    if (json.containsKey("Maintenance")) {
      maintenance = Maintenance.fromJson(json['Maintenance']);
    }
    if (json.containsKey("sensor")) {
      sensor = Sensor.fromJson(json['sensor']);
    }
    if (json.containsKey("option_mdvr")) {
      optionMvr = OptionMvr.fromJson(json['option_mdvr']);
    }
    if (json.containsKey("option_snapshot")) {
      optionSnapshots = List.from(json['option_snapshot'])
          .map((a) => OptionSnapshot.fromJson(a))
          .toList();
    }
    if (json.containsKey("dlt_regulation")) {
      final data = json['dlt_regulation'] as Map;

      for (final name in data.keys) {
        final value = data[name];
        var a = Behavior();
        a.value = value;
        a.name = name;
        listDlt.add(a);
      }
    }
    if (json.containsKey("driving_behavior")) {
      final data = json['driving_behavior'] as Map;

      for (final name in data.keys) {
        final value = data[name];
        var a = Behavior();
        a.value = value;
        a.name = name;
        listBehavior.add(a);
      }
    }
  }
}
