import 'package:intl/intl.dart';

class Reservation {
  String id;
  String customer_id;
  String restaurant_id;
  String table_id;
  String comment;
  String requested_at;
  String created_at;
  String customer_name;
  String restaurant_name;

  String h;
  String m;

  Reservation() {}

  Reservation.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap["id"].toString();
    customer_id = jsonMap["customer_id"].toString();
    restaurant_id = jsonMap["restaurant_id"].toString();
    table_id = jsonMap["table_id"].toString();
    comment = jsonMap["comment"];
    requested_at = jsonMap["requested_at"];
    created_at = jsonMap["created_at"];
    customer_name = jsonMap["first_name"] + " " + jsonMap["last_name"];
    restaurant_name = jsonMap["restaurant_name"];
    try {} catch (e) {
      print(e);
    }
  }

  Map toMap() {
    requested_at =
        "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${h.length < 2 ? "0$h" : h}:${m.length < 2 ? "0$m" : m}:00";
    var map = new Map<String, dynamic>();
    map["restaurant_id"] = restaurant_id;
    map["table_id"] = table_id;
    map["requested_at"] = requested_at;
    return map;
  }

  Map toTimeMap() {
    String time =
        "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${h.length < 2 ? "0$h" : h}:${m.length < 2 ? "0$m" : m}:00";
    var map = new Map<String, dynamic>();
    map["restaurant_id"] = restaurant_id;
    map["time"] = time;
    return map;
  }
}
