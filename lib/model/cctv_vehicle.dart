

class CctvVehicle {
  String? terid;
  int? vehicleId;
  String? vehicleName;
  String? licensePlateNo;
  String? vinNo;
  int? status;

  CctvVehicle.fromJson(Map<String, dynamic> json) {
    terid = json['terid'];
    vehicleId = json['vehicle_id'];
    vehicleName = json['vehicle_name'];
    licensePlateNo = json['license_plate_no'];
    vinNo = json['vin_no'];
    status = json['status'];
  }
}
