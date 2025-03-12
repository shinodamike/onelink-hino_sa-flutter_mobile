
import 'package:iov/model/noti.dart';
import 'package:iov/model/vehicle.dart';

class NotiGroup {
  String? name;
  List<Noti> notifications = [];
  List<Vehicle> vehicle = [];

  NotiGroup({String? name}) {
    this.name = name;
    notifications = [];
    vehicle = [];
  }
}
