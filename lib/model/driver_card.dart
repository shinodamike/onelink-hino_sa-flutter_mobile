
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/language_en.dart';
import 'package:iov/localization/language/language_jp.dart';
import 'package:iov/localization/language/language_th.dart';

class DriverCard {
  String? card_id;
  String? name;
  String? driver_phone;

  int? status_swipe_card;

  DriverCard.fromJson(Map<String, dynamic> json) {
    card_id = json['card_id'];
    name = json['name'];
    status_swipe_card = json['status_swipe_card'];
    driver_phone = json['driver_phone'];

    if (card_id == null || card_id!.isEmpty || card_id! == "-") {

      if (Api.language == "th") {
        card_id = LanguageTh().unidentified_driver;
      } else if (Api.language == "ja") {
        card_id = LanguageJp().unidentified_driver;
      } else {
        card_id = LanguageEn().unidentified_driver;
      }
    }
    if (name == null || name!.isEmpty) {
      name = card_id;
    }
    if (name == null || name!.isEmpty) {
      if (Api.language == "th") {
        name = LanguageTh().unidentified_driver;
      } else if (Api.language == "ja") {
        name = LanguageJp().unidentified_driver;
      } else {
        name = LanguageEn().unidentified_driver;
      }
    }
  }
}
