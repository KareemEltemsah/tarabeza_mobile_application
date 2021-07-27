class TopHour {
  String hour;
  String hourly_orders;

  TopHour();

  TopHour.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      hour = jsonMap['hour'];
      hourly_orders = jsonMap['hourly_orders'].toString();
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['hour'] = hour;
    map['hourly_orders'] = hourly_orders;
    return map;
  }
}
