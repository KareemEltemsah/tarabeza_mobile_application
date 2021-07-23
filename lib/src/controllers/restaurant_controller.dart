import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  GlobalKey<ScaffoldState> scaffoldKey;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
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
  }

  Future<void> getRestaurantMenu() async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}menu/${restaurant.id}';
    final client = new http.Client();
    final menuResponse = await client.get(url);
    setState(() {
      items =
          (json.decode(menuResponse.body)['data']['items'] as List)
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
      reviews = (json.decode(reviewsResponse.body)['data']
              ['restaurant_reviews'] as List)
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
    setState(() {
      tables = (json.decode(tablesResponse.body)['data'] as List)
          .map((i) => RestaurantTable.fromJSON(i))
          .where((element) => element.id != null)
          .toList();
    });
  }

  Future<bool> addReview(String comment, int rate) async {
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
}
