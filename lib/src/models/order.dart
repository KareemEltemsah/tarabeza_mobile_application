import '../models/order_item.dart';

class Order {
  String id;
  String customer_id;
  String restaurant_id;
  String table_id;
  String table_number;
  bool is_finished;
  bool is_approved;
  bool is_deleted;
  String created_at;
  String customer_name;
  String restaurant_name;

  List<OrderItem> orderItems = <OrderItem>[];

  Order() {
    orderItems = [];
  }

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap["id"].toString();
    customer_id = jsonMap["customer_id"].toString();
    restaurant_id = jsonMap["restaurant_id"].toString();
    table_id = jsonMap["table_id"].toString();
    table_number = jsonMap["table_number"].toString();
    is_finished = jsonMap["is_finished"].toString() == "1" ? true : false;
    is_approved = jsonMap["is_approved"].toString() == "1" ? true : false;
    is_deleted = jsonMap["is_deleted"].toString() == "1" ? true : false;
    created_at = jsonMap["created_at"];
    customer_name = jsonMap["first_name"] + " " + jsonMap["last_name"];
    restaurant_name = jsonMap["restaurant_name"];
    orderItems.add(new OrderItem.fromJSON(jsonMap));
    try {} catch (e) {
      orderItems = [];
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["customer_id"] = customer_id;
    map["restaurant_id"] = restaurant_id;
    map["table_id"] = table_id;
    map["table_number"] = table_number;
    map["items"] = orderItems?.map((element) => element.toMap())?.toList();
    return map;
  }

  Map idToMap() {
    var map = new Map<String, dynamic>();
    map["order_id"] = id;
    return map;
  }

  double getTotalPrice() {
    double price = 0;
    orderItems.forEach((element) {
      price += element.getTotalPrice();
    });
    return price;
  }
}
