class ModelDataHistoryWorkVehicle {
  late ModelVehicleData mdVehicleData;
  late ModelWorkingData mdWorkingData;

  @override
  String toString() {
    return 'ModelDataHistoryWorkVehicle{mdVehicleData:$mdVehicleData,mdWorkingData:$mdWorkingData}';
  }
}

class ModelVehicleData {
  int vid = 0;
  String vehicleName = "";
  String vinNo = "";
  String modelCode = "";
  String chassisNo = "";
  String engineNo = "";
  String dealerName = "";
  String customerName = "";
  String phone = "";
  String leasedNo = "";
  String deliveryDate = "";
  int engineHour = 0;
  String location = "";
  String gpsDate = "";
  double workingHourStart = 0;
  double workingHourStop = 0;
  double workingHour = 0;


  //  "vid": 39920,
  //         "vehicle_name": "",
  //         "vin_no": "YMRVIO50JNBJ62059",
  //         "model_code": "VIO50-P",
  //         "chassis_no": "YMRVIO50JNBJ62059",
  //         "engine_no": "187946",
  //         "dealer_name": "บริษัท ยันม่าร์ เอส.พี. จำกัด",
  //         "customer_name": "Siam Kanamoto Co.,Ltd.",
  //         "phone": "021081241",
  //         "leased_no": "0000",
  //         "delivery_date": "2022-10-10",
  //         "engine_hour": 1563.7,
  //         "location": "Na Di Mueang Samut Sangkhron Samut Sakhon",
  //         "gps_date": "2023-06-11 14:29:44",
  //         "working_hour_start": 1539.9,
  //         "working_hour_stop": 1558.0,
  //         "working_hour": 18.1


  // ModelVehicleData({
  //   required this.vid,
  //   required this.vehicleName,
  //   required this.vinNo,
  //   required this.modelCode,
  //   required this.chassisNo,
  //   required this.engineNo,
  //   required this.dealerName,
  //   required this.customerName,
  //   required this.phone,
  //   required this.leasedNo,
  //   required this.deliveryDate,
  //   required this.engineHour,
  //   required this.location,
  //   required this.gpsDate,
  //   required this.workingHourStart,
  //   required this.workingHourStop,
  //   required this.workingHour,
  // });

  @override
  String toString() {
    return 'ModelVehicleData{ vid:$vid,vehicleName :$vehicleName,vinNo:$vinNo,modelCode:$modelCode,chassisNo :$chassisNo,engineNo :$engineNo,dealerName :$dealerName,customerName :$customerName,phone :$phone,leasedNo :$leasedNo,deliveryDate :$deliveryDate,engineHour :$engineHour,location :$location,gpsDate :$gpsDate,workingHourStart :$workingHourStart,workingHourStop :$workingHourStop, workingHour :$workingHour}';
  }
}

class ModelWorkingData {
  String sData = '';
  String totalWorkingInHour = '';
  List<ModelWorkDate> working = [];

  ModelWorkingData({
    required this.sData,
    required this.totalWorkingInHour,
    required this.working,
  });

  @override
  String toString() {
    return 'ModelWorkingData{sData:$sData,totalWorkingInHour:$totalWorkingInHour,working:$working}';
  }
}




class ModelWorkDate {
  String start = '';
  String stop = '';

  ModelWorkDate({
    required this.start,
    required this.stop,
  });
  @override
  String toString() {
    return 'ModelWorkDate{start:$start,stop:$stop}';
  }
}
