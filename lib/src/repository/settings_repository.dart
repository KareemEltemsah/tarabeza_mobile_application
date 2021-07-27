import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/setting.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<bool> useCaching = new ValueNotifier(false);
final navigatorKey = GlobalKey<NavigatorState>();

Future<Setting> initSettings() async {
  Setting _setting = new Setting();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _setting.brightness.value =
      prefs.getBool('isDark') ?? false ? Brightness.dark : Brightness.light;
  setting.value = _setting;
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  setting.notifyListeners();
  return setting.value;
}

Future<void> setCachingOption() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('cachingDate')) {
    DateTime cachingDate = DateTime.parse(prefs.getString('cachingDate'));
    useCaching.value =
        DateTime.now().difference(cachingDate).inHours < 6 ? true : false;
  } else
    useCaching.value = false;
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  useCaching.notifyListeners();
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}

Future<void> saveMessageId(String messageId) async {
  if (messageId != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('google.message_id', messageId);
  }
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get('google.message_id');
}
