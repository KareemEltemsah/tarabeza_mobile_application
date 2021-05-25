import '../models/item.dart';

class OrderItem {
  String id;
  Item item;
  int quantity;

  OrderItem(Item i, int q, this.id) {
    item = i;
    quantity = q;
  }

  OrderItem.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      /*price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;*/
    } catch (e) {
      /*price = 0.0;
      quantity = 0.0;
      item = item.fromJSON({});*/
    }
  }

  double getTotalPrice() {
    return item.getPrice() * quantity;
  }

  bool operator ==(dynamic other) {
    return other.item == this.item;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    /*map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;*/
    return map;
  }
}
