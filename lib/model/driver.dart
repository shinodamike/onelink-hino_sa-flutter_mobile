
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/language_en.dart';
import 'package:iov/localization/language/language_jp.dart';
import 'package:iov/localization/language/language_th.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/utils/utils.dart';

class Driver {
  int? id;
  int? score;
  String? prefix;
  String? firstname;
  String? lastname;
  String? personalId;
  String? photoUrl;
  String? datetimeSwipe;
  String? imei;
  int? statusSwipeCard;
  String? licensePlateNo;
  String? vehicleName;
  var lat;
  var lng;
  String? adminLevel3Name;
  String? adminLevel2Name;
  String? adminLevel1Name;
  Vehicle? vehicle;

  String? driver_phone_no;
  String? box_phone_no;

  String? display_datetime_swipe;
  String? display_last_updated;
  String? card_id;

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    score = json['score'];
    prefix = json['prefix'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    personalId = json['personal_id'];
    photoUrl = json['photo_url'];
    datetimeSwipe = json['datetime_swipe'];
    imei = json['imei'];
    statusSwipeCard = json['status_swipe_card'];
    licensePlateNo = json['license_plate_no'];
    vehicleName = json['vehicle_name'];
    lat = json['lat'];
    lng = json['lng'];
    // adminLevel3Name = json['admin_level3_name'];
    // adminLevel2Name = json['admin_level2_name'];
    // adminLevel1Name = json['admin_level1_name'];
    if (Api.language == "en") {
      adminLevel3Name = json['admin_level3_name_en'];
      adminLevel2Name = json['admin_level2_name_en'];
      adminLevel1Name = json['admin_level1_name_en'];
    } else {
      adminLevel3Name = json['admin_level3_name'];
      adminLevel2Name = json['admin_level2_name'];
      adminLevel1Name = json['admin_level1_name'];
    }
    // adminLevel3NameEn = json['admin_level3_name_en'];
    // adminLevel2NameEn = json['admin_level2_name_en'];
    // adminLevel1NameEn = json['admin_level1_name_en'];

    display_datetime_swipe = json['display_datetime_swipe'];
    display_last_updated = json['display_last_updated'];

    vehicle = Utils.getVehicleByLicense(licensePlateNo!);

    if (vehicleName == null || vehicleName!.isEmpty || vehicleName! == "-") {
      vehicleName = licensePlateNo;
    }
    card_id = json['card_id'] ?? "";
    if (firstname == null || firstname!.isEmpty) {
      firstname = card_id;
    }

    if (firstname == null || firstname!.isEmpty) {
      // firstname = "ไม่ระบุผู้ขับขี่";

      if (Api.language == "th") {
        firstname = LanguageTh().unidentified_driver;
      } else if (Api.language == "ja") {
        firstname = LanguageJp().unidentified_driver;
      } else {
        firstname = LanguageEn().unidentified_driver;
      }
    }

    driver_phone_no = json['driver_phone_no'];
    box_phone_no = json['box_phone_no'];
    driver_phone_no ??= "";
    box_phone_no ??= "";
  }
}
