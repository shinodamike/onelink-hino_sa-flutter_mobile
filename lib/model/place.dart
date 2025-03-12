// import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iov/model/factory.dart';
import 'package:iov/model/vehicle.dart';

class Place {
   Factory? factory;
   Vehicle? vehicle;
  final LatLng latLng;

  Place({this.factory,this.vehicle, required this.latLng});

  @override
  LatLng get location => latLng;
}