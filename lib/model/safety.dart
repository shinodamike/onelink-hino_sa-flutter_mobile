
import 'package:iov/api/api.dart';

class Safety {


  String? arg ;
  var avg ;
  var point ;


  Safety.fromJson(Map<String, dynamic> json) {
    arg = mapName(json['arg']);
    avg = json['avg'];
    point = json['point'];

  }

  mapName(String name){
    if(Api.language=="en"){
      if(name=="harsh_start"){
        return "Harsh Start";
      }else if(name=="harsh_acceleration"){
        return "Harsh Acceleration";
      }else if(name=="harsh_brake"){
        return "Harsh Brake";
      }else if(name=="sharp_turn"){
        return "Sharp Turn";
      }else if(name=="exceeding_speed"){
        return "Exceeding Speed";
      }else if(name=="exceeding_rpm"){
        return "Exceeding RPM";
      }else{
        return name;
      }
    }else if (Api.language == "ja") {
      if (name == "exceeding_speed") {
        return "スピード出し過ぎ";
      } else if (name == "exceeding_rpm") {
        return "ふかし過ぎ";
      } else if (name == "harsh_start") {
        return "急発進";
      } else if (name == "harsh_acceleration") {
        return "急加速";
      } else if (name == "harsh_brake") {
        return "急ブレーキ";
      } else if (name == "sharp_turn") {
        return "急旋回";
      } else {
        return name;
      }
    }else{
      if(name=="harsh_start"){
        return "การออกตัว";
      }else if(name=="harsh_acceleration"){
        return "การเร่งความเร็ว";
      }else if(name=="harsh_brake"){
        return "การใช้เบรค";
      }else if(name=="sharp_turn"){
        return "การเลี้ยว";
      }else if(name=="exceeding_speed"){
        return "การใช้ความเร็ว";
      }else if(name=="exceeding_rpm"){
        return "การใช้รอบเครื่อง";
      }else{
        return name;
      }
    }

  }
}

