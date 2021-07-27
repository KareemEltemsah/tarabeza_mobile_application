import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarabeza_mobile_application/src/models/reservation.dart';

import '../models/category.dart';
import '../models/item.dart';
import '../models/table.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import 'filter_controller.dart';
import 'package:http/http.dart' as http;
import '../repository/user_repository.dart' as userRepo;

class RestaurantController extends ControllerMVC {
  Restaurant restaurant;
  List<Item> items = <Item>[];
  List<Category> categories = <Category>[];
  List<Review> reviews = <Review>[];
  List<RestaurantTable> tables = <RestaurantTable>[];

  List<Item> selectedItems = <Item>[];
  ValueNotifier<List<RestaurantTable>> availableTables =
      new ValueNotifier(<RestaurantTable>[]);
  List<Item> recommendedItems = <Item>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void> getRecommendationsByCategory(String category_id) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}menu/recommend/${restaurant.id}/${category_id}';
    final client = new http.Client();
    final menuResponse = await client.get(url);
    print(menuResponse);
    List<String> _IDs = new List<String>();
    _IDs = (json.decode(menuResponse.body)['data'] as List)
        .map((i) => i["id"].toString())
        .toList();
    setState(() {
      recommendedItems =
          items.where((element) => _IDs.contains(element.id)).toList();
    });
  }

  Future<void> getRestaurant(String id) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}restaurants/${id}';
    final client = new http.Client();
    final restaurantResponse = await client.get(url);
    setState(() {
      restaurant = Restaurant.fromJSON(
          (json.decode(restaurantResponse.body)['data']['restaurant_data']
                  as List)
              .elementAt(0));
    });
    await calculateRestaurantRate();
  }

  Future<void> calculateRestaurantRate() async {
    await getRestaurantReviews();
    double sum = 0;
    reviews.forEach((element) {
      sum += double.parse(element.rate);
    });
    setState(() {
      restaurant.rating =
          !reviews.isEmpty ? (sum / reviews.length)?.toStringAsFixed(1) : "0";
    });
  }

  Future<void> getRestaurantMenu() async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}menu/${restaurant.id}';
    final client = new http.Client();
    final menuResponse = await client.get(url);
    setState(() {
      items = (json.decode(menuResponse.body)['data']['items'] as List)
          .map((i) => Item.fromJSON(i))
          .where((element) => element.id != null)
          .toList();
    });
    selectedItems = items;
    await getRestaurantCategories();
  }

  Future<void> getRestaurantCategories() async {
    List<String> categoriesIDs = new List<String>();
    categoriesIDs.add('0');
    items.forEach((e) => categoriesIDs.add(e.category_id));
    // print(categoriesIDs);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('categories')) {
      List prefsCat =
          (json.decode(await prefs.getString('categories')) as List);
      setState(() {
        categories = prefsCat
            .map((e) => Category.fromJSON(e))
            .where((element) => categoriesIDs.contains(element.id))
            .toList();
      });
    } else {
      FilterController FC = new FilterController();
      setState(() {
        categories = FC.categories
            .where((element) => categoriesIDs.contains(element.id))
            .toList();
      });
    }
  }

  Future<void> getRestaurantReviews() async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}reviews/${restaurant.id}';
    final client = new http.Client();
    final reviewsResponse = await client.get(url);
    setState(() {
      reviews = (json.decode(reviewsResponse.body)['data']['restaurant_reviews']
              as List)
          .map((i) => Review.fromJSON(i))
          .where((element) => element.id != null)
          .toList();
    });
  }

  Future<void> getRestaurantTables(String id) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}tables/${id}';
    final client = new http.Client();
    final tablesResponse = await client.get(url);
    // print(tablesResponse.body);
    setState(() {
      tables = (json.decode(tablesResponse.body)['data'] as List)
          .map((i) => RestaurantTable.fromJSON(i))
          .where((element) => element.id != null)
          .toList();
    });
  }

  Future<void> getAvailableTables(Reservation reservation) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}tables/available';
    final client = new http.Client();
    final tablesResponse =
        await client.post(url, body: json.encode(reservation.toTimeMap()));
    tablesResponse.statusCode == 200
        ? setState(() {
            availableTables.value =
                (json.decode(tablesResponse.body)['data'] as List)
                    .map((i) => RestaurantTable.fromJSON(i))
                    .where((element) => element.id != null)
                    .toList();
          })
        : null;
  }

  Future<void> getRestaurantTablesNoState(String id) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}tables/${id}';
    final client = new http.Client();
    final tablesResponse = await client.get(url);
    // print(tablesResponse.body);
    tables = (json.decode(tablesResponse.body)['data'] as List)
        .map((i) => RestaurantTable.fromJSON(i))
        .where((element) => element.id != null)
        .toList();
  }

  Future<void> addTable(RestaurantTable table) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}tables';
    final client = new http.Client();
    final addResponse = await client.post(
      url,
      body: json.encode(table.toMap()),
    );
    // print(addResponse.body);
    getRestaurantTables(table.restaurant_id);
  }

  Future<void> holdTable(RestaurantTable table) async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}'
        'tables/hold/${table.restaurant_id}/${table.id}';
    final client = new http.Client();
    final holdResponse = await client.get(url);
    // print(holdResponse.body);
      getRestaurantTables(table.restaurant_id);
  }

  Future<void> releaseTable(RestaurantTable table) async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}'
        'tables/release/${table.restaurant_id}/${table.id}';
    final client = new http.Client();
    final releaseResponse = await client.get(url);
    // print(releaseResponse.body);
      getRestaurantTables(table.restaurant_id);
  }

  Future<String> getTableNumberByID(String rest_id, String table_id) async {
    await getRestaurantTablesNoState(rest_id);
    try {
      return tables
          .elementAt(tables.indexWhere((element) => element.id == table_id))
          .number;
    } catch (e) {
      print(e);
      return "#";
    }
  }

  Future<void> addReview(String comment, int rate) async {
    print("$comment $rate");
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}reviews/add';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: json.encode({
        "customer_name": "${userRepo.currentUser.value.fullName()}",
        "restaurant_id": "${restaurant.id ?? ""}",
        "comment": "${comment}",
        "rate": "${rate}"
      }),
    );
    print(response.body);
    return (response.statusCode == 201) ? true : false;
  }

  Future<void> selectCategory(List<String> categoriesId) async {
    if (!categoriesId.isEmpty) {
      if (categoriesId.length == 1 && categoriesId.contains('0'))
        selectedItems = items;
      else
        selectedItems = items
            .where((element) => categoriesId.contains(element.category_id))
            .toList();
    }
    categoriesId != ['0']
        ? getRecommendationsByCategory(categoriesId.elementAt(0))
        : clearRecommendations();
  }

  void clearRecommendations() {
    setState(() {
      recommendedItems.clear();
    });
  }

  Future<void> selectByName(String searchWord) async {
    selectedItems = selectedItems
        .where((element) =>
            element.name.toLowerCase().contains(searchWord.toLowerCase()))
        .toList();
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant.id;
    restaurant = new Restaurant();
    getRestaurant(_id);
  }

  Future<bool> addReservation(Reservation reservation) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}customer/reservations';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: json.encode(reservation.toMap()),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${userRepo.currentUser.value.apiToken}'
      },
    );
    print(reservation.toMap());
    print(response.body);
    return (response.statusCode == 201) ? true : false;
  }
}
