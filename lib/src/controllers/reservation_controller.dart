import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import '../models/reservation.dart';

import '../models/reservation.dart';
import '../repository/user_repository.dart' as userRepo;

class ReservationController extends ControllerMVC {
  List<Reservation> reservations = <Reservation>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ReservationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<bool> makeReservation(Reservation reservation) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}'
        'customer/reservations/${userRepo.currentUser.value.customer_id}';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: json.encode(reservation.toMap()),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${userRepo.currentUser.value.apiToken}'},
    );
    return (response.statusCode == 201) ? true : false;
  }

  Future<void> getUserReservations() async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}'
        'customer/reservations/${userRepo.currentUser.value.customer_id}';
    final client = new http.Client();
    final reservationsResponse = await client.get(url);
    // print(reservationsResponse.body);
    setState(() {
      reservations = (jsonDecode(reservationsResponse.body)["data"] as List)
          .map((e) => Reservation.fromJSON(e))
          .where((element) => element.id != null)
          .toList();
    });
  }

  Future<void> getRestaurantReservations() async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}'
        'restaurant/reservations/${userRepo.currentUser.value.restaurant_id}';
    final client = new http.Client();
    final reservationsResponse = await client.get(url);
    // print(reservationsResponse.body);
    setState(() {
      reservations = (jsonDecode(reservationsResponse.body)["data"] as List)
          .map((e) => Reservation.fromJSON(e))
          .where((element) => element.id != null)
          .toList();
    });
  }
}
