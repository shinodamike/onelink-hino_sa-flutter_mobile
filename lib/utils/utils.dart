import 'dart:math';
//FIXME : Comment awesome_notifications and firebase_messaging.
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/driver.dart';
import 'package:iov/model/noti.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/page/home_realtime.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:intl/intl.dart';


class Utils {
  static String convertDateFromMilli(String? selectedDate) {
    if (selectedDate == null) {
      return "";
    }
    var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(selectedDate);
    return DateFormat('d MMM yyyy').format(date);
  }

  static String convertDateToBase(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) {
      return "";
    }
    // print(selectedDate);
    // var date =
    // DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC(selectedDate).toLocal();
    // return DateFormat('d MMM yy HH:mm').format(date);
    try {
      var date =
          DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC(selectedDate).toLocal();
      return DateFormat('d MMM yy HH:mm').format(date);
    } catch (e) {
      return selectedDate;
    }
  }

  static String convertDateToDay(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) {
      return "";
    }
    // print(selectedDate);
    // var date =
    // DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC(selectedDate).toLocal();
    // return DateFormat('d MMM yy HH:mm').format(date);
    try {
      var date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(selectedDate);
      return DateFormat('d MMM yy').format(date);
    } catch (e) {
      return selectedDate;
    }
  }

  static String convertDateToBaseReal(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) {
      return "";
    }
    try {
      var date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(selectedDate);
      return DateFormat('d MMM yy HH:mm').format(date);
    } catch (e) {
      return selectedDate;
    }
  }

  static String convertDatePlayback(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) {
      return "";
    }
    var date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(selectedDate);
    return DateFormat('d MMM yy HH:mm:ss').format(date);
  }

  static String convertDate(DateTime? selectedDate) {
    if (selectedDate == null) {
      return "";
    }
    return DateFormat('d MMM yyyy').format(selectedDate);
  }

  static String convertDatePickup(String? selectedDate) {
    if (selectedDate == null) {
      return "";
    }
    var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(selectedDate);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static DateTime convertDatePickupDateTime(String? selectedDate) {
    if (selectedDate == null) {
      return DateTime.now();
    }
    var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(selectedDate);
    return date;
  }

  static String getDateGraph(String? selectedDate) {
    if (selectedDate == null) {
      return "";
    }
    try {
      var date = DateFormat('yyyy-MM-dd').parse(selectedDate);
      return "${DateFormat('d MMM').format(date)}\n${DateFormat('yyyy').format(date)}";
    } catch (e) {
      return selectedDate;
    }
  }

  // 2021-09-28T07:27:37.873Z
  static getDateCreate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static getDateTimeCreate() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  static getDateBackYear() {
    var d = DateTime.now().subtract(const Duration(days: 30));
    return DateFormat('yyyy-MM-dd').format(d);
  }

  static getDatePickup(String selectedDate) {
    var date = DateFormat('dd/MM/yyyy').parse(selectedDate);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static dateFromServerToPost(String selectedDate) {
    var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(selectedDate);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static Widget getRisk(int? riskId) {
    if (riskId == null) {
      return Container();
    }
    if (riskId == 0) {
      return const Icon(
        Icons.circle,
        color: Colors.red,
        size: 40,
      );
    } else if (riskId == 1) {
      return const Icon(
        Icons.circle,
        color: Colors.yellow,
        size: 40,
      );
    } else {
      return const Icon(
        Icons.circle,
        color: Colors.green,
        size: 40,
      );
    }
  }

  static showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorCustom.primaryColor, // Set the background color here
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static String numberFormat(double number) {
    var formatter = NumberFormat('#,###,##0.0');
    try {
      return formatter.format(number);
    } catch (e) {
      return number.toString();
    }
  }

  static String numberFormatInt(int number) {
    var formatter = NumberFormat('#,###,##0');
    try {
      return formatter.format(number);
    } catch (e) {
      return number.toString();
    }
  }

  static Widget statusCarImage(String status, var speed) {
    if (Api.language == "th") {
      switch (status.toLowerCase()) {
        case "driving":
          return Image.asset(
            "assets/images/car_icon.png",
            width: 60,
            height: 60,
          );
        case "ign.off":
          return Image.asset("assets/images/car_icon2.png",
              width: 60, height: 60);
        case "parking":
          return Image.asset("assets/images/car_icon2.png",
              width: 60, height: 60);
        case "idling":
          return Image.asset("assets/images/car_icon3.png",
              width: 60, height: 60);
        case "offline":
          return Image.asset("assets/images/icon_offline.png",
              width: 60, height: 60);
        case "over_speed":
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ColorCustom.over_speed2,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  speed.toStringAsFixed(0),
                  style: const TextStyle(
                      color: ColorCustom.over_speed,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'กม/ชม',
                  style: TextStyle(
                      color: ColorCustom.over_speed,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
      }
    } else {
      switch (status.toLowerCase()) {
        case "driving":
          return Image.asset(
            "assets/images/icon_driving_en.png",
            width: 60,
            height: 60,
          );
        case "ign.off":
          return Image.asset("assets/images/icon_parking_en.png",
              width: 60, height: 60);
        case "parking":
          return Image.asset("assets/images/icon_parking_en.png",
              width: 60, height: 60);
        case "idling":
          return Image.asset("assets/images/icon_idle_en.png",
              width: 60, height: 60);
        case "offline":
          return Image.asset("assets/images/icon_offline_en.png",
              width: 60, height: 60);
        case "over_speed":
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ColorCustom.over_speed2,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  speed.toStringAsFixed(0),
                  style: const TextStyle(
                      color: ColorCustom.over_speed,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'km/h',
                  style: TextStyle(
                      color: ColorCustom.over_speed,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
      }
    }

    return Image.asset("assets/images/car_icon.png", width: 60, height: 60);
  }

  static Widget eventIcon(Noti no, BuildContext context) {
    switch (no.event_id) {
      case 1001:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ColorCustom.over_speed2,
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                no.speed.toString(),
                style: const TextStyle(
                    color: ColorCustom.over_speed,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                Languages.of(context)!.km_h,
                style: const TextStyle(
                    color: ColorCustom.over_speed,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      case 10000:
        return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.handyman,
              size: 30,
              color: Colors.black,
            ));
      case 10001:
        return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.bus_alert,
              size: 30,
              color: Colors.white,
            ));
    }
    return Container();
  }

  // List data1 = [
  //   "ความเร็วเกินกำหนด",
  //   "เข้าพื้นที่เสี่ยง",
  //   "ออกพื้นที่เสี่ยง",
  //   "แจ้งเตือนเข้าศูนย์บริการ",
  //   "ไฟเครื่องยนต์เตือน"
  // ];
  static String eventTitle(int eventId) {
    switch (eventId) {
      case 1001:
        return "ความเร็วเกินกำหนด";
      case 1004:
        return "เข้าพื้นที่เสี่ยง";
      case 1007:
        return "ออกพื้นที่เสี่ยง";
      case 10000:
        return "แจ้งเตือนเข้าศูนย์บริการ";
      case 10001:
        return "ไฟเครื่องยนต์เตือน";
      case 7:
        return "ออกตัวกระทันหัน";
      case 9:
        return "เร่งความเร็วกระทันหัน";
      case 14:
        return "เบรกกระแทก";
      case 21:
        return "เลี้ยวรุนแรง";
      case 1010:
        return "รูดบัตรขับรถ";
      case 1011:
        return "รูดบัตรเลิกขับ";
    }
    return "";
  }

  static String eventTitleEn(int eventId) {
    switch (eventId) {
      case 1001:
        return "Over Speed";
      case 1004:
        return "Enter hazard zone";
      case 1007:
        return "Exit hazard zone";
      case 10000:
        return "Maintenance Remind";
      case 10001:
        return "Engine Lamp";
      case 7:
        return "Harsh Start";
      case 9:
        return "Harsh Acceleration";
      case 14:
        return "Harsh Brake";
      case 21:
        return "Sharp Turn";
      case 1010:
        return "Swipe Card";
      case 1011:
        return "Not Swipe Card";
    }
    return "";
  }

  static Widget swipeCard(Driver driver, BuildContext context) {
    switch (driver.statusSwipeCard) {
      case 0:
        return Row(
          children: [
            const Icon(
              Icons.credit_card,
              size: 20,
              color: Colors.red,
            ),
            Text(
              Languages.of(context)!.no_swipe_card,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.credit_card,
                  size: 20,
                  color: Colors.green,
                ),
                Text(
                  Languages.of(context)!.swipe_card,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        );
      case 2:
        return Row(
          children: [
            const Icon(
              Icons.credit_card,
              size: 20,
              color: Colors.orange,
            ),
            Text(
              Languages.of(context)!.wrong_license,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 14,
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            const Icon(
              Icons.credit_card,
              size: 20,
              color: Colors.grey,
            ),
            Text(
              Languages.of(context)!.expire_card,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        );
    }
    return Container();
  }

  static Vehicle? getVehicleByLicense(String license) {
    for (Vehicle v in listVehicle) {
      if (v.info!.licenseplate == license) {
        return v;
      }
    }
    return null;
  }

  static Vehicle? getVehicleByVinNo(String vinNo) {
    for (Vehicle v in listVehicle) {
      if (v.info!.vin_no == vinNo) {
        return v;
      }
    }
    return null;
  }

  static String mapEcoName(String name) {
    if (Api.language == "en") {
      if (name == "Exhaust Brake/Retarder") {
        return "Exhaust Brake Retarder";
      }
      return name;
    } else if (Api.language == "ja") {
      if (name == "Long Idling") {
        return "長時間アイドル";
      } else if (name == "Exhaust Brake/Retarder") {
        return "エキゾーストブレーキ\nリターダー";
      } else if (name == "RPM High Speed") {
        return "高速走行時の\nE/G\n回転数";
      } else if (name == "RPM Low Speed") {
        return "低速走行時の\nE/G\n回転数";
      } else if (name == "Shift Up & Exceeding RPM") {
        return "シフトアップの\n時にふかし過ぎ";
      } else if (name == "Shift Down & Exceeding RPM") {
        return "シフトダウンの\n時にふかし過ぎ";
      }
    } else {
      if (name == "Long Idling") {
        return "จอดไม่ดับเครื่อง";
      } else if (name == "Exhaust Brake/Retarder") {
        return "เบรคไอเสียรีทาร์ดเดอร์";
      } else if (name == "RPM High Speed") {
        return "รอบเครื่องที่ความเร็วสูง";
      } else if (name == "RPM Low Speed") {
        return "รอบเครื่องที่ความเร็วต่ำ";
      } else if (name == "Shift Up & Exceeding RPM") {
        return "การเพิ่มเกียร์";
      } else if (name == "Shift Down & Exceeding RPM") {
        return "การลดเกียร์";
      }
    }

    return name;
  }

  static String mapSafetyName(String name) {
    if (Api.language == "en") {
      return name;
    } else if (Api.language == "ja") {
      if (name == "Exceeding Speed") {
        return "スピード出し過ぎ";
      } else if (name == "Exceeding RPM") {
        return "ふかし過ぎ";
      } else if (name == "Harsh Start") {
        return "急発進";
      } else if (name == "Harsh Acceleration") {
        return "急加速";
      } else if (name == "Harsh Brake") {
        return "急ブレーキ";
      } else if (name == "Sharp Turn") {
        return "急旋回";
      }
    } else {
      if (name == "Exceeding Speed") {
        return "การใช้ความเร็ว";
      } else if (name == "Exceeding RPM") {
        return "การใช้รอบเครื่อง";
      } else if (name == "Harsh Start") {
        return "การออกตัว";
      } else if (name == "Harsh Acceleration") {
        return "การเร่งความเร็ว";
      } else if (name == "Harsh Brake") {
        return "การใช้เบรค";
      } else if (name == "Sharp Turn") {
        return "การเลี้ยว";
      }
    }

    return name;
  }

  static String mapDltName(String name) {
    if (Api.language == "en") {
      if (name == "dlt_4hour") {
        return "DLT Driving Continuous 4h";
      } else if (name == "dlt_8hour") {
        return "DLT Driving Over 8h per Day";
      } else if (name == "dlt_overspeed") {
        return "DLT Driving Over Speed";
      } else if (name == "dlt_unknown") {
        return "DLT Not Swipe Driving License Card";
      } else if (name == "dlt_unplug") {
        return "DLT GPS Unplugged";
      } else if (name == "dlt_wrongtype") {
        return "DLT Wrong Type License Card";
      }
    } else if (Api.language == "ja") {
      if (name == "dlt_4hour") {
        return "4時間以上の連続走行";
      } else if (name == "dlt_8hour") {
        return "日あたり8時間以上の走行";
      } else if (name == "dlt_overspeed") {
        return "スピード超過";
      } else if (name == "dlt_unknown") {
        return "免許証を認証出来なかった";
      } else if (name == "dlt_unplug") {
        return "GPS機器が外された";
      } else if (name == "dlt_wrongtype") {
        return "免許証タイプが一致しませんでした";
      }
    } else {
      if (name == "dlt_4hour") {
        return "ขับขี่ต่อเนื่องเกิน 7 ชม.";
      } else if (name == "dlt_8hour") {
        return "ขับขี่ต่อวันเกิน 8 ชม.";
      } else if (name == "dlt_overspeed") {
        return "ความเร็วเกินกำหนด";
      } else if (name == "dlt_unknown") {
        return "ไม่รูดใบขับขี่";
      } else if (name == "dlt_unplug") {
        return "จีพีเอสไม่เชื่อมกับขนส่ง";
      } else if (name == "dlt_wrongtype") {
        return "ใบขับขี่ผิดประเภท";
      }
    }

    return name;
  }

  static String mapDrivingName(String name) {
    if (Api.language == "en") {
      if (name == "harsh_acceleration") {
        return "Harsh Acceleration";
      } else if (name == "harsh_brake") {
        return "Harsh Brake";
      } else if (name == "harsh_start") {
        return "Harsh Start";
      } else if (name == "overspeed_100") {
        return "Over Speed 100 km/h";
      } else if (name == "overspeed_120") {
        return "Over Speed 120 km/h";
      } else if (name == "overspeed_60") {
        return "Over Speed 60 km/h";
      } else if (name == "overspeed_80") {
        return "Over Speed 80 km/h";
      } else if (name == "sharp_turn") {
        return "Sharp Turn";
      }
    } else if (Api.language == "ja") {
      if (name == "harsh_acceleration") {
        return "急加速";
      } else if (name == "harsh_brake") {
        return "急ブレーキ";
      } else if (name == "harsh_start") {
        return "急発進";
      } else if (name == "overspeed_100") {
        return "速度超過 100 km/h以上";
      } else if (name == "overspeed_120") {
        return "速度超過 120 km/h以上";
      } else if (name == "overspeed_60") {
        return "速度超過 60 km/h以上";
      } else if (name == "overspeed_80") {
        return "速度超過 80 km/h以上";
      } else if (name == "sharp_turn") {
        return "急旋回";
      }
    } else {
      if (name == "harsh_acceleration") {
        return "เร่งความเร็วกระทันหัน";
      } else if (name == "harsh_brake") {
        return "เร่งความเร็วกระทันหัน";
      } else if (name == "harsh_start") {
        return "ออกตัวกระทันหัน";
      } else if (name == "overspeed_100") {
        return "ความเร็วเกิน 100 กม/ชม.";
      } else if (name == "overspeed_120") {
        return "ความเร็วเกิน 120 กม/ชม.";
      } else if (name == "overspeed_60") {
        return "ความเร็วเกิน 60 กม/ชม.";
      } else if (name == "overspeed_80") {
        return "ความเร็วเกิน 80 กม/ชม.";
      } else if (name == "sharp_turn") {
        return "เลี้ยวกระทันหัน";
      }
    }

    return name;
  }

  static String mapIconVehicle(int id) {
    if (id == 2) {
      return "1.png";
    } else if (id == 3) {
      return "2.png";
    } else if (id == 4) {
      return "6.png";
    } else if (id == 5) {
      return "4.png";
    } else if (id == 6) {
      return "4.png";
    } else if (id == 7) {
      return "5.png";
    } else if (id == 8) {
      return "5.png";
    } else if (id == 9) {
      return "5.png";
    } else if (id == 10) {
      return "8.png";
    } else if (id == 11) {
      return "8.png";
    } else if (id == 12) {
      return "9.png";
    } else if (id == 13) {
      return "4.png";
    } else if (id == 14) {
      return "7.png";
    } else if (id == 15) {
      return "5.png";
    } else if (id == 22) {
      return "8.png";
    } else if (id == 25) {
      return "6.png";
    }

    return "5.png";
  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value.toDouble();
    }
  }

  static showAlertDialogEmpty(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: const Text("Go back"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("No data found"),
      content: const Text("Please Try Again"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static String channelId = "1000";
  static String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  static String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  static sendNotification(String title, String message, String unix) async {
    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //     channelId, channelName,
    //     channelDescription: channelDescription,
    //     importance: Importance.max,
    //     priority: Priority.high);
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    //
    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics,
    //     iOS: iOSPlatformChannelSpecifics);
    Random random = Random();
    int randomNumber = random.nextInt(1000);
    // var myInt = int.parse(unix);
    // await flutterLocalNotificationsPlugin.show(
    //     randomNumber, title, message, platformChannelSpecifics,
    //     payload: unix);
    // AwesomeNotifications().incrementGlobalBadgeCounter();
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //       id: randomNumber,
    //       channelKey: 'iov_noti',
    //       title: title,
    //       body: message),
    // );
  }

  static bool isLoad = false;

  static void loadingProgress(BuildContext context) {
    isLoad = true;
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(color: ColorCustom.primaryColor),
          Container(margin: const EdgeInsets.only(left: 5), child: const Text("Loading..")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
