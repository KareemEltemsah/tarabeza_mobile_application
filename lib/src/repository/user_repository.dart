import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'order_repository.dart' as orderRepo;

ValueNotifier<User> currentUser = new ValueNotifier(User());

Future<User> login(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_urlX')}';
  final client = new http.Client();
  final loginResponse = await client.post(
    url + 'auth/me',
    body: json.encode(user.toMap(login: true)),
  );
  print(json.encode(user.toMap(login: true)));
  if (loginResponse.statusCode == 200) {
    print(loginResponse.body);
    String token = json.decode(loginResponse.body)['data']['token'];
    await getUserData(token);
    await getUserRoleData();
    setCurrentUser(currentUser.value.toMap());
    print(currentUser.value);
  } else {
    print(loginResponse.body);
    throw new Exception(loginResponse.body);
  }
  return currentUser.value;
}

Future<User> register(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}';
  final client = new http.Client();
  final signUpResponse = await client.post(
    url + 'auth/register',
    body: json.encode(user.toMap(signUp: true)),
  );
  print(json.encode(user.toMap(signUp: true)));
  if (signUpResponse.statusCode == 201) {
    print(signUpResponse.body);
    String token = json.decode(signUpResponse.body)['data']['token'];
    await getUserData(token);
    await getUserRoleData();
    setCurrentUser(currentUser.value.toMap());
    print(currentUser.value);
  } else {
    print(signUpResponse.body);
    throw new Exception(signUpResponse.body);
  }
  return currentUser.value;
}

Future<void> getUserData(String token) async {
  final String url = '${GlobalConfiguration().getValue('api_base_urlX')}';
  final client = new http.Client();
  final userResponse = await client.get(
    url + 'users/me',
    headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'},
  );
  currentUser.value = User.fromJSON(json.decode(userResponse.body)['data']);
  currentUser.value.apiToken = token;
}

Future<void> getUserRoleData() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}';
  final client = new http.Client();
  if (currentUser.value.role == "customer") {
    final customerResponse = await client.get(
      url + 'customer/${currentUser.value.id}',
    );
    currentUser.value.addCustomerData(
      (json.decode(customerResponse.body)['data'] as List).elementAt(0),
    );
  }
}

Future<bool> resetPassword(User user) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}send_reset_link_email';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    print(response.body);
    throw new Exception(response.body);
  }
}

Future<void> logout() async {
  currentUser.value = new User();
  orderRepo.clearOrderItems();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
  if (prefs.containsKey('cachingDate')) prefs.remove('cachingDate');
}

void setCurrentUser(userMap) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('current_user', json.encode(userMap));
  if (prefs.containsKey('cachingDate')) prefs.remove('cachingDate');
  orderRepo.clearOrderItems();
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
    currentUser.value =
        User.fromJSON(json.decode(await prefs.get('current_user')));
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}
