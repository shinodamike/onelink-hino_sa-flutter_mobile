
import 'package:iov/model/cctv_date_channel.dart';

import 'cctv_date_date.dart';

class CctvDate {
  List<CctvDateDate> listDate = [];
  List<CctvDateChannel> listChannel = [];

  CctvDate.fromJson(Map<String, dynamic> json) {
    listDate =
        List.from(json['data']).map((a) => CctvDateDate.fromJson(a)).toList();
    listChannel = List.from(json['channel_info'])
        .map((a) => CctvDateChannel.fromJson(a))
        .toList();
    listDate.sort((b, a) => a.date!.compareTo(b.date!));
  }
}
