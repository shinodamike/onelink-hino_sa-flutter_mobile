import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iov/utils/utils.dart';

import 'factory_latlng.dart';

class Factory {
  String? geofenceTypeName;
  int? id;
  int? radius;
  String? geomTypeName;
  String? location_name_3;
  String? location_name_2;
  String? coordinate;
  String? updatedDateTime;
  String? location_name_1;
  String? iconPoint;
  String? name;
  String? description;
  String? url;

  double lat = 0.0;
  double lng = 0.0;
  List vid_list = [];
  List<LatLng> coordinateList = [];

  Factory.fromJson(Map<String, dynamic> jsons) {
    geofenceTypeName = jsons['geofenceTypeName'];
    id = jsons['id'];
    radius = jsons['radius'];
    geomTypeName = jsons['geomTypeName'];
    location_name_3 = jsons['location_name_3'];
    location_name_2 = jsons['location_name_2'];
    coordinate = jsons['coordinate'];
    updatedDateTime = jsons['updatedDateTime'];
    location_name_1 = jsons['location_name_1'];
    iconPoint = jsons['iconPoint'];
    name = jsons['name'];
    description = jsons['description'];

    if (jsons.containsKey("url")) {
      url = jsons['url'];
    }
    if (jsons.containsKey("vid_list")) {
      vid_list = jsons['vid_list'];
    }

    var a = json.decode(iconPoint!);
    var list = List.from(a).map((a) => FactoryLatLng.fromJson(a)).toList();
    lat = list[0].lat is int ? 0.0 : list[0].lat;
    lng = list[0].lng is int ? 0.0 : list[0].lng;

    var b = json.decode(coordinate!);
    List list2 = List.from(b).map((b) => FactoryLatLng.fromJson(b)).toList();
    for (FactoryLatLng l in list2) {
      coordinateList.add(LatLng(Utils.checkDouble(l.lat),Utils.checkDouble(l.lng)));
    }
  }
}
