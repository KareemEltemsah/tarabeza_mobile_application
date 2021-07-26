enum UserRole { customer }

class User {
  String id;
  String email;
  String phone;
  String role;
  String first_name;
  String last_name;
  String gender;
  String DOB;
  bool is_active;
  bool is_banned;
  String confirmation_code;

  String password;
  String apiToken;
  String deviceToken;

  //customer data
  String customer_id;
  String address;
  String longitude;
  String latitude;

  //staff data
  String restaurant_id;

  // used for indicate if client logged in or not
  bool auth;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      email = jsonMap['email'] ?? '';
      phone = jsonMap['phone_number'] ?? '';
      role = jsonMap['role'] ?? '';
      first_name = jsonMap['first_name'] ?? '';
      last_name = jsonMap['last_name'] ?? '';
      gender = jsonMap['gender'] ?? '';
      DOB = jsonMap['date_of_birth'] ?? '';
      is_active = jsonMap['is_active'].toString() == '1' ? true : false;
      is_banned = jsonMap['is_banned'].toString() == '1' ? true : false;
      confirmation_code = jsonMap['confirmation_code'] ?? '';

      if (jsonMap.containsKey('api_token')) apiToken = jsonMap['api_token'];
      if (jsonMap.containsKey('customer_id'))
        customer_id = jsonMap['customer_id'].toString();
      if (jsonMap.containsKey('address')) address = jsonMap['address'];
      if (jsonMap.containsKey('longitude')) longitude = jsonMap['longitude'];
      if (jsonMap.containsKey('latitude')) latitude = jsonMap['latitude'];

      if (jsonMap.containsKey('restaurant_id'))
        restaurant_id = jsonMap['restaurant_id'].toString();
    } catch (e) {
      print(e);
    }
  }

  Map toMap({
    bool login: false,
    bool signUp: false,
    bool update: false,
    bool updateCheck: false,
  }) {
    bool none = !login && !signUp && !update && !updateCheck;
    var map = new Map<String, dynamic>();
    map["email"] = email;
    if (signUp || login || update) map["password"] = password;
    if (signUp || update || updateCheck || none) {
      map["phone_number"] = phone;
      map["role"] = role;
      map["first_name"] = first_name;
      map["last_name"] = last_name;
      map["gender"] = gender;
      map["date_of_birth"] = DOB;
      if ((role == "staff" || role == "restaurant_manager") && (signUp || none))
        map["restaurant_id"] = restaurant_id;
    }
    if (update || updateCheck || none) map["id"] = id;
    if (none) {
      map["is_active"] = is_active;
      map["is_banned"] = is_banned;
      map["confirmation_code"] = confirmation_code;
      map["api_token"] = apiToken;
      if (deviceToken != null) {
        map["device_token"] = deviceToken;
      }

      if (role == "customer") {
        map["customer_id"] = customer_id;
        map["address"] = address;
        map["longitude"] = longitude;
        map["latitude"] = latitude;
      }
    }
    return map;
  }

  addRoleData(Map<String, dynamic> jsonMap) {
    try {
      if (role == "customer") {
        customer_id = jsonMap['id'].toString();
        address = jsonMap['address'].toString();
        longitude = jsonMap['longitude'].toString();
        latitude = jsonMap['latitude'].toString();
      } else if (role == "staff" || role == "restaurant_manager")
        restaurant_id = jsonMap['restaurant_id'].toString();
    } catch (e) {
      print(e);
    }
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

  bool profileCompleted() {
    return phone != null && phone != '';
  }

  String fullName() {
    return first_name + ' ' + last_name;
  }
}
