
import 'package:iov/api/api.dart';

class Location {

  String? admin_level3_name;
  String? admin_level2_name;
  String? admin_level1_name;
  // String? admin_level3_name_en;
  // String? admin_level2_name_en;
  // String? admin_level1_name_en;

  Location.fromJson(Map<String, dynamic> json) {
    if(Api.language=="en"||Api.language=="ja"){
      admin_level3_name = json['admin_level3_name_en'];
      admin_level2_name = json['admin_level2_name_en'];
      admin_level1_name = json['admin_level1_name_en'];
    }else{
      admin_level3_name = json['admin_level3_name'];
      admin_level2_name = json['admin_level2_name'];
      admin_level1_name = json['admin_level1_name'];
    }

  }
}
