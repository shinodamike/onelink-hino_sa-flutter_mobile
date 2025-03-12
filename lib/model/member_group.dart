
import 'package:iov/model/member.dart';
import 'package:iov/model/vehicle.dart';

class MemberGroup {
  String? name;
  List<Member> members = [];
  List<Vehicle> vehicle = [];
  bool isExpand = false;
  bool isSelect = true;

  MemberGroup({String? name}) {
    this.name = name;
    members = [];
    vehicle = [];
  }
}
