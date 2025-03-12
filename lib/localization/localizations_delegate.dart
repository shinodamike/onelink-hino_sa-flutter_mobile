import 'package:flutter/material.dart';
import 'package:iov/localization/language/language_jp.dart';
import 'language/language_en.dart';
import 'language/language_th.dart';
import 'language/languages.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'th','ja'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'th':
        return LanguageTh();
      case 'ja':
        return LanguageJp();
      default:
        return LanguageTh();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
