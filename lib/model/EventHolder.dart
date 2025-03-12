
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventHolder {

  LatLng latlng = const LatLng(0, 0);
  double course = 0;
  String date = "";

  EventHolder({required LatLng l,required double c,required String d}){
    course = c;
    latlng = l;
    date = d;
  }
}
