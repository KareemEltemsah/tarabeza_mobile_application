import 'dart:convert';

import '../models/user.dart';
import '../models/order_item.dart';
import '../models/restaurant.dart';

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

  List<OrderItem> orderItems;

  Order() {
    orderItems = [];
  }

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
    } catch (e) {
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

  double getTotalPrice() {
    double price = 0;
    orderItems.forEach((element) {
      price += element.getTotalPrice();
    });
    print(toMap());
    print(json.encode(toMap()));
    return price;
  }
}
