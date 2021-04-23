
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

  // String address;

  // used for indicate if client logged in or not
  bool auth;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      phone = jsonMap['phone_number'] != null ? jsonMap['phone_number'] : '';
      role = jsonMap['role'] != null ? jsonMap['role'] : '';
      first_name = jsonMap['first_name'] != null ? jsonMap['first_name'] : '';
      last_name = jsonMap['last_name'] != null ? jsonMap['last_name'] : '';
      gender = jsonMap['gender'] != null ? jsonMap['gender'] : '';
      DOB = jsonMap['date_of_birth'] != null ? jsonMap['date_of_birth'] : '';
      is_active = jsonMap['is_active'] == '1' ? true : false;
      is_banned = jsonMap['is_banned'] == '1' ? true : false;
      confirmation_code = jsonMap['confirmation_code'];
      if (jsonMap.containsKey('api_token')) apiToken = jsonMap['api_token'];
      // deviceToken = jsonMap['device_token'];
      // address = jsonMap['address'];
    } catch (e) {
      print(e);
    }
  }

  Map toMap({bool login: false, bool signUp: false}) {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    if (signUp || login) map["password"] = password;
    if (signUp || (!login && !signUp)) {
      map["phone_number"] = phone;
      map["role"] = role;
      map["first_name"] = first_name;
      map["last_name"] = last_name;
      map["gender"] = gender;
      map["date_of_birth"] = DOB;
    }
    if (!login && !signUp) {
      map["id"] = id;
      map["is_active"] = is_active;
      map["is_banned"] = is_banned;
      map["confirmation_code"] = confirmation_code;
      map["api_token"] = apiToken;
      if (deviceToken != null) {
        map["device_token"] = deviceToken;
      }
    }
    // map["address"] = address;
    return map;
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
