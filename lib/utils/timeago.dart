import 'package:iov/api/api.dart';
import 'package:intl/intl.dart';

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    try {
      DateTime notificationDate =
          DateFormat("yyyy-MM-dd HH:mm:ss").parseUTC(dateString).toLocal();
      final date2 = DateTime.now();
      final difference = date2.difference(notificationDate);
      if (Api.language == "th") {
        if (difference.inDays > 8) {
          return dateString;
        } else if ((difference.inDays / 7).floor() >= 1) {
          return (numericDates) ? '1 อาทิตย์ที่แล้ว' : 'อาทิตย์ที่แล้ว';
        } else if (difference.inDays >= 2) {
          return '${difference.inDays} วันที่แล้ว';
        } else if (difference.inDays >= 1) {
          return (numericDates) ? '1 วันที่แล้ว' : 'เมื่อวาน';
        } else if (difference.inHours >= 2) {
          return '${difference.inHours} ชั่วโมงที่แล้ว';
        } else if (difference.inHours >= 1) {
          return (numericDates) ? '1 ชั่วโมงที่แล้ว' : 'ชั่วโมงที่แล้ว';
        } else if (difference.inMinutes >= 2) {
          return '${difference.inMinutes} นาทีที่แล้ว';
        } else if (difference.inMinutes >= 1) {
          return (numericDates) ? '1 นาทีที่แล้ว' : 'นาทีที่แล้ว';
        } else if (difference.inSeconds >= 3) {
          return '${difference.inSeconds} วินาทีที่แล้ว';
        } else {
          return 'เมื่อสักครู่';
        }
      } else {
        if (difference.inDays > 8) {
          return dateString;
        } else if ((difference.inDays / 7).floor() >= 1) {
          return (numericDates) ? '1 week ago' : 'Last week';
        } else if (difference.inDays >= 2) {
          return '${difference.inDays} days ago';
        } else if (difference.inDays >= 1) {
          return (numericDates) ? '1 day ago' : 'Yesterday';
        } else if (difference.inHours >= 2) {
          return '${difference.inHours} hours ago';
        } else if (difference.inHours >= 1) {
          return (numericDates) ? '1 hour ago' : 'An hour ago';
        } else if (difference.inMinutes >= 2) {
          return '${difference.inMinutes} minutes ago';
        } else if (difference.inMinutes >= 1) {
          return (numericDates) ? '1 minute ago' : 'A minute ago';
        } else if (difference.inSeconds >= 3) {
          return '${difference.inSeconds} seconds ago';
        } else {
          return 'Just now';
        }

      }
    } catch (e) {
      return dateString;
    }
  }

  static String timeAgoSinceDateNoti(String dateString,
      {bool numericDates = true}) {
    try {
      DateTime notificationDate =
          DateFormat("dd MMM yy").parseUTC(dateString).toLocal();
      final date2 = DateTime.now();
      print("notificationDate:$notificationDate");
      print("date:$date2");

      if (date2.day == notificationDate.day) {
        if(Api.language == "en"){
          return "Today";
        }else  if(Api.language == "ja"){
          return "今日";
        }else{
          return "วันนี้";
        }

      } else if (date2.subtract(const Duration(days: 1)).day ==
          notificationDate.day) {
        if(Api.language == "en"){
          return "Yesterday";
        }else  if(Api.language == "ja"){
          return "昨日";
        }else{
          return "เมื่อวาน";
        }
      } else {
        return dateString;
      }
    } catch (e) {
      print(e);
      return "";
    }
  }
}
