import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:iov/model/vehicle.dart';

class PageProvider with ChangeNotifier {
  Vehicle? _is_select_vehicle;

  Vehicle? get is_select_vehicle => _is_select_vehicle;

  void selectVehicle(Vehicle? v) {
    _is_select_vehicle = v;
    notifyListeners();
  }


}