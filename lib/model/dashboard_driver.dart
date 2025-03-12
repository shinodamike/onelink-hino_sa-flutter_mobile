

class DashboardDriver {
  int? total;
  int? unitSwipecard;
  String? ioNameSwipecard;
  String? ioColorSwipecard;
  int? unitNotSwipecard;
  String? ioNameNotSwipecard;
  String? ioColorNotSwipecard;
  int? unitValidate;
  String? ioNameValidate;
  String? ioColorValidate;


  DashboardDriver.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    unitSwipecard = json['unit_swipecard'];
    ioNameSwipecard = json['io_name_swipecard'];
    ioColorSwipecard = json['io_color_swipecard'];
    unitNotSwipecard = json['unit_not_swipecard'];
    ioNameNotSwipecard = json['io_name_not_swipecard'];
    ioColorNotSwipecard = json['io_color_not_swipecard'];
    unitValidate = json['unit_validate'];
    ioNameValidate = json['io_name_validate'];
    ioColorValidate = json['io_color_validate'];
  }
}