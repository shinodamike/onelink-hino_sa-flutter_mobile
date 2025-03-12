class DropdownRegion {
  String sVal = '';
  int regionId = 0;
  String regionName = "";
  List<ModelRegion> listDropdownRegion = [];

  DropdownRegion({
    required this.sVal,
    required this.regionId,
    required this.regionName,
    required this.listDropdownRegion,
  });
}

class ModelRegion {
  int region_id = 0;
  String region_nameEN = '';
  String region_nameTH = '';

  ModelRegion({
    required this.region_id,
    required this.region_nameEN,
    required this.region_nameTH,
  });
}

class DropdownDealer {
  String sVal = '';
  int dealerId = 0;
  String dealerName = "";
  List<DropdownInfoVehicle> listDealer = [];

  DropdownDealer({
    required this.sVal,
    required this.dealerId,
    required this.dealerName,
    required this.listDealer,
  });

  @override
  String toString() {
    return 'DropdownDealer{sVal:$sVal,dealerId:$dealerId,dealerName:$dealerName,listDealer: $listDealer}';
  }
}

class DropdownInfoVehicle {
  String sVal = '';
  int dealerId = 0;
  String dealerName = "";
  List<InfoVehicle> listInfoVehicle = [];

  DropdownInfoVehicle({
    required this.sVal,
    required this.dealerId,
    required this.dealerName,
    required this.listInfoVehicle,
  });

  @override
  String toString() {
    return 'DropdownInfoVehicle{sVal:$sVal,dealerId:$dealerId,dealerName:$dealerName,listInfoVehicle: $listInfoVehicle}';
  }
}

class InfoVehicle {
  int vid = 0;
  int fleetId = 0;
  String modelCode = '';
  String chassisNo = '';
  String engineNo = '';
  int customerId = 0;

  InfoVehicle({
    required this.vid,
    required this.fleetId,
    required this.modelCode,
    required this.chassisNo,
    required this.engineNo,
    required this.customerId,
  });
}

//---------------------------------

class DropdownCustomer {
  String sVal = '';
  int partnerId = 0;
  String partnerName = "";
  List<CustomerInfo> listInfoCustomer = [];

  DropdownCustomer({
    required this.sVal,
    required this.partnerId,
    required this.partnerName,
    required this.listInfoCustomer,
  });

  @override
  String toString() {
    return 'DropdownInfoVehicle{sVal:$sVal,partnerId:$partnerId,partnerName:$partnerName,listInfoCustomer: $listInfoCustomer}';
  }
}

class CustomerInfo {
  int partner_id = 0;
  String prefix = "";
  String firstname = "";
  String lastname = "";
  String suffix = "";

  CustomerInfo({
    required this.partner_id,
    required this.prefix,
    required this.firstname,
    required this.lastname,
    required this.suffix,
  });
}
