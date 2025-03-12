

class DashboardRealtime {
  int? total;
  int? unitParking;
  String? ioNameParking;
  String? ioColorParking;
  int? unitIdling;
  String? ioNameIdling;
  String? ioColorIdling;
  int? unitDriving;
  String? ioNameDriving;
  String? ioColorDriving;
  int? unitOffline;
  String? ioNameOffline;
  String? ioColorOffline;
  int? unitOverspeed;
  String? ioNameOverspeed;
  String? ioColorOverspeed;


  DashboardRealtime.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    unitParking = json['unit_parking'];
    ioNameParking = json['io_name_parking'];
    ioColorParking = json['io_color_parking'];
    unitIdling = json['unit_idling'];
    ioNameIdling = json['io_name_idling'];
    ioColorIdling = json['io_color_idling'];
    unitDriving = json['unit_driving'];
    ioNameDriving = json['io_name_driving'];
    ioColorDriving = json['io_color_driving'];
    unitOffline = json['unit_offline'];
    ioNameOffline = json['io_name_offline'];
    ioColorOffline = json['io_color_offline'];
    unitOverspeed = json['unit_overspeed'];
    ioNameOverspeed = json['io_name_overspeed'];
    ioColorOverspeed = json['io_color_overspeed'];
  }
}