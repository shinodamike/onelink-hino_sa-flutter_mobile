
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iov/model/driver_card.dart';
import 'package:iov/model/fleet.dart';
import 'package:iov/model/info.dart';

import 'gps.dart';

class Vehicle{


  Fleet? fleet ;
  Info? info ;
  Gps? gps ;
  DriverCard? driverCard;
  BitmapDescriptor? icon;

  int searchType = 0;
  bool isSelect = true;

  Vehicle.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("fleet")){
      fleet = Fleet.fromJson(json['fleet']);
    }

    info = Info.fromJson(json['info']);
    gps = Gps.fromJson(json['gps']);
    driverCard = DriverCard.fromJson(json['driver_cards']);



  }

}

