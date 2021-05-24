import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import '../models/item.dart';
import '../models/restaurant.dart';
import 'filter_controller.dart';
import 'package:http/http.dart' as http;
import '../repository/category_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';

class RestaurantController extends ControllerMVC {
  Restaurant restaurant;
  List<Item> items = <Item>[];
  List<Item> selectedItems = <Item>[];
  List<Category> categories = <Category>[];

  // List<Item> trendingItems = <Item>[];
  // List<Item> featuredItems = <Item>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void> getRestaurant({String id, String message}) async {
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
    setState(() {
      items = (json.decode(restaurantResponse.body)['data']['items'] as List)
          .map((i) => Item.fromJSON(i))
          .toList();
    });
    items.add(Item.fromJSON({
      "id": "1",
      "restaurant_id": "4795",
      "category_id": "1",
      "name": "test 1 a",
      "description": "",
      "price": "1",
      "discount": "0",
      "image": "",
      "is_available": "1",
      "created_at": "2021-03-20 20:29:53",
      "updated_at": "2021-03-20 20:29:53",
      "category_name": "Beverages"
    }));
    items.add(Item.fromJSON({
      "id": "1",
      "restaurant_id": "4795",
      "category_id": "2",
      "name": "test 2 b",
      "description": "",
      "price": "1",
      "discount": "0",
      "image": "",
      "is_available": "1",
      "created_at": "2021-03-20 20:29:53",
      "updated_at": "2021-03-20 20:29:53",
      "category_name": "Beverages"
    }));
    items.add(Item.fromJSON({
      "id": "1",
      "restaurant_id": "4795",
      "category_id": "3",
      "name": "test 3 c",
      "description": "",
      "price": "1",
      "discount": "0.3",
      "image": "",
      "is_available": "1",
      "created_at": "2021-03-20 20:29:53",
      "updated_at": "2021-03-20 20:29:53",
      "category_name": "Beverages"
    }));
    selectedItems = items;
    getRestaurantCategories();
  }

  Future<void> getRestaurantCategories() async {
    List<String> categoriesIDs = new List<String>();
    categoriesIDs.add('0');
    items.forEach((e) => categoriesIDs.add(e.category_id));
    print(categoriesIDs);
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
        .where((element) => element.name.contains(searchWord))
        .toList();
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant.id;
    restaurant = new Restaurant();
    getRestaurant(
      id: _id, /*message: S.of(context).restaurant_refreshed_successfuly*/
    );
  }
}
