import 'package:flutter/material.dart';

class Setting {
  String appName = '';
  String defaultCurrency;
  String distanceUnit;
  bool currencyRight = false;
  int currencyDecimalDigits = 2;

  String mainColor;
  String mainDarkColor;
  String secondColor;
  String secondDarkColor;
  String accentColor;
  String accentDarkColor;
  String scaffoldDarkColor;
  String scaffoldColor;

  // String googleMapsKey;
  // String fcmKey;
  ValueNotifier<Locale> mobileLanguage = new ValueNotifier(Locale('en', ''));
  String appVersion;
  bool enableVersion = true;
  List<String> homeSections = [];

  ValueNotifier<Brightness> brightness = new ValueNotifier(Brightness.light);

  Setting() {
    appName = 'Tarabeza';
    mainColor = '#ea5c44';
    mainDarkColor = '#ea5c44';
    secondColor = '#344968';
    secondDarkColor = '#ccccdd';
    accentColor = '#8c98a8';
    accentDarkColor = '#9999aa';
    scaffoldDarkColor = '#2c2c2c';
    scaffoldColor = '#fafafa';
    //googleMapsKey = '';
    //fcmKey = '';
    mobileLanguage.value = Locale('en', '');
    appVersion = 'Demo';
    distanceUnit = 'km';
    enableVersion = true;
    defaultCurrency = "\$";
    currencyDecimalDigits = 2;
    currencyRight = false;

    var HS = {
      "home_section_1": "recent_restaurants_heading",
      "home_section_2": "recent_restaurants",
      "home_section_3": "recent_items_heading",
      "home_section_4": "recent_items",
      "home_section_5": "recommended_restaurants_heading",
      "home_section_6": "recommended_restaurants",
    };
    for (int _i = 1; _i <= 6; _i++) {
      homeSections.add(HS['home_section_' + _i.toString()] != null
          ? HS['home_section_' + _i.toString()]
          : 'empty');
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['app_name'] = appName;
    map['default_currency'] = defaultCurrency;
    map['default_currency_decimal_digits'] = currencyDecimalDigits;
    map['mobile_language'] = mobileLanguage.value.languageCode;
    return map;
  }
}
