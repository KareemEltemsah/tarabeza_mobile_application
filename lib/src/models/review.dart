import '../models/restaurant.dart';
import '../models/user.dart';

class Review {
  String id;
  String customer_name;
  String restaurant_id;
  String rate;
  String comment;
  String created_at;

  Review();

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      customer_name = jsonMap['customer_name'];
      restaurant_id = jsonMap['restaurant_id'].toString();
      rate = jsonMap['rate'].toString();
      comment = jsonMap['comment'] ?? '';
      created_at = jsonMap['created_at'];
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["customer_name"] = customer_name;
    map["restaurant_id"] = restaurant_id;
    map["rate"] = rate;
    map["comment"] = comment;
    map["created_at"] = created_at;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }
}
