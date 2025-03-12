import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIcon  {
   BitmapDescriptor? icon;
   String? name;
   Uint8List? iconByte;

   MarkerIcon(BitmapDescriptor icon,String name,Uint8List iconByte){
     this.icon = icon;
     this.name = name;
     this.iconByte = iconByte;
   }


}