class RestaurantTable {
  String id;
  String number;
  String restaurant_id;
  String no_of_chairs;
  bool is_reserved;

  RestaurantTable();

  RestaurantTable.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      number = jsonMap['number'].toString();
      restaurant_id = jsonMap['restaurant_id'].toString();
      no_of_chairs = jsonMap['no_of_chairs'].toString();
      is_reserved = jsonMap['is_reserved'].toString() == '1' ? true : false;
    } catch (e) {
      print(e);
    }
  }
}
