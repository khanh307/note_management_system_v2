import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String languadeCode = 'languageCode';

//languages code
const String english = 'en';
const String vietnam = 'vi';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languadeCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode1 = prefs.getString(languadeCode) ?? english;
  return _locale(languageCode1);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, '');
    case vietnam:
      return const Locale(vietnam, "");
    default:
      return const Locale(english, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
