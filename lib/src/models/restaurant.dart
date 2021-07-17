import 'package:flutter/material.dart';

import 'user.dart';

class Restaurant {
  String id;
  String name;
  String logo_url;
  String contact_number;
  String address;
  String longitude;
  String latitude;
  String rating;
  String number_of_ratings;
  bool reservation_active;
  String opening_time;
  String closing_time;
  String review_count;
  String distance;

  Restaurant();

  Restaurant.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] ?? '';
      logo_url = jsonMap['logo_url'] ?? '';
      contact_number = jsonMap['contact_number'] ?? '';
      address = jsonMap['address'] ?? '';
      longitude = jsonMap['longitude'].toString() ?? '';
      latitude = jsonMap['latitude'].toString() ?? '';
      rating = jsonMap['rating'].toString();
      number_of_ratings = jsonMap['number_of_ratings'].toString();
      reservation_active = jsonMap['reservation_active'].toString() == '1' ? true : false;
      opening_time = jsonMap['opening_time'];
      closing_time = jsonMap['closing_time'];
      review_count = jsonMap['review_count'].toString();
      distance = jsonMap['distance'] ?? null;
    } catch (e) {}
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "logo_url": logo_url,
      "contact_number": contact_number,
      "address": address,
      "longitude": longitude,
      "latitude": latitude,
      "rating": rating,
      "number_of_ratings": number_of_ratings,
      "reservation_active": reservation_active ? '1' : '0',
      "opening_time": opening_time,
      "closing_time": closing_time,
      "review_count": review_count,
      "distance": distance
    };
  }

  bool isClosed() {
    TimeOfDay closing = TimeOfDay(
        hour: int.parse(closing_time.substring(0, 2)),
        minute: int.parse(closing_time.substring(3, 5)));
    double _closing_time = closing.hour + closing.minute / 60;
    double now = TimeOfDay.now().hour + TimeOfDay.now().minute / 60;
    return now >= _closing_time ? true : false;
  }

  String getTimeInfo() {
    return "<p>Everyday ${modifyTime(opening_time)}${dayOrNight(opening_time)} - ${modifyTime(closing_time)}${dayOrNight(closing_time)}</p>";
  }

  String modifyTime(String t) {
    return t = (int.parse(t.substring(0, 2)) <= 12
            ? t.substring(0, 2)
            : (int.parse(t.substring(0, 2)) - 12).toString()) +
        t.substring(2, 5);
  }

  dayOrNight(String t) {
    return int.parse(t.substring(0, 2)) < 12 ? 'AM' : 'PM';
  }
}
