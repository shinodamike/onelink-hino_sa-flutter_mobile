
import 'package:iov/api/api.dart';

class Eco {
  String? arg;

  var avg;

  var point;

  Eco.fromJson(Map<String, dynamic> json) {
    arg = mapName(json['arg']);
    avg = json['avg'];
    point = json['point'];
  }

  mapName(String name) {
    if (Api.language == "en") {
      if (name == "rpm_high") {
        return "RPM High Speed";
      } else if (name == "rpm_low") {
        return "RPM Low Speed";
      } else if (name == "shift_up") {
        return "Shift Up & Exceeding RPM";
      } else if (name == "shift_down,") {
        return "Shift Down & Exceeding RPM";
      } else if (name == "long_idling") {
        return "Long Idling";
      } else if (name == "exhaust_brake") {
        return "Exhaust Brake Retarder";
      } else {
        return name;
      }
    } else if (Api.language == "ja") {
      if (name == "long_idling") {
        return "長時間アイドル";
      } else if (name == "exhaust_brake") {
        return "エキゾーストブレーキ\nリターダー";
      } else if (name == "rpm_high") {
        return "高速走行時の\nE/G\n回転数";
      } else if (name == "rpm_low") {
        return "低速走行時の\nE/G\n回転数";
      } else if (name == "shift_up") {
        return "シフトアップの\n時にふかし過ぎ";
      } else if (name == "shift_down") {
        return "シフトダウンの\n時にふかし過ぎ";
      } else {
        return name;
      }
    } else {
      if (name == "rpm_high") {
        return "รอบเครื่องที่ความเร็วสูง";
      } else if (name == "rpm_low") {
        return "รอบเครื่องที่ความเร็วต่ำ";
      } else if (name == "shift_up") {
        return "การเพิ่มเกียร์";
      } else if (name == "shift_down,") {
        return "การลดเกียร์";
      } else if (name == "long_idling") {
        return "จอดไม่ดับเครื่อง";
      } else if (name == "exhaust_brake") {
        return "เบรคไอเสียรีทาร์ดเดอร์";
      } else {
        return name;
      }
    }
  }
}
