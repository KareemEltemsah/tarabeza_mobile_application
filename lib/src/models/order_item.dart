import '../models/item.dart';

class OrderItem {
  String id;
  String item_name;
  int qty;

  Item item;


  OrderItem(Item i, int q, this.id) {
    item = i;
    qty = q;
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
    return item.getPrice() * qty;
  }

  bool operator ==(dynamic other) {
    return other.item == this.item;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["meal_id"] = item.id;
    map["quantity"] = qty;
    map["comment"] = "";
    map["total"] = getTotalPrice();
    return map;
  }


}
