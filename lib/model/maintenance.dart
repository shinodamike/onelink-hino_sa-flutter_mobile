
class Maintenance {

  String? Insurance;
  int? Next_service;
  String? Tires_Service;

  Maintenance.fromJson(Map<String, dynamic> json) {
    Insurance = json['Insurance'];
    Next_service = json['Next_service'];
    Tires_Service = json['Tires_Service'];
  }
}
