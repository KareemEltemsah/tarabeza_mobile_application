import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import '../models/restaurant.dart';
import '../repository/user_repository.dart' as userRepo;
import '../repository/settings_repository.dart' as settingsRepo;

class HomeController extends ControllerMVC {
  List<Restaurant> recentRestaurants = <Restaurant>[];
  List<Item> recentItems = <Item>[];
  List<Restaurant> recommendedRestaurants = <Restaurant>[];

  HomeController() {
    settingsRepo.setCachingOption().whenComplete(() {
      print(settingsRepo.useCaching.value
          ? 'caching enabled'
          : 'caching disabled');
      userRepo.currentUser.value.apiToken != null
          ? getFeedsForUser(userRepo.currentUser.value.id)
          : getFeeds();
    });
  }

  Future<void> getFeeds() async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}feeds';
    print(url);
    final client = new http.Client();
    try {
      final feedsResponse = await client.get(url);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        if (prefs.containsKey('recentRestaurants') &&
            settingsRepo.useCaching.value) {
          print('recentRestaurants from prefs');
          recentRestaurants =
              (json.decode(prefs.getString('recentRestaurants')) as List)
                  .map((e) => Restaurant.fromJSON(e))
                  .toList();
        } else {
          recentRestaurants = (json.decode(feedsResponse.body)['data']
                  ['recent_restaurants'] as List)
              .map((e) => Restaurant.fromJSON(e))
              .toList();
          saveRecentRestaurants();
        }
      });
      setState(() {
        if (prefs.containsKey('recentItems') && settingsRepo.useCaching.value) {
          print('recentItems from prefs');
          recentItems = (json.decode(prefs.getString('recentItems')) as List)
              .map((e) => Item.fromJSON(e))
              .toList();
        } else {
          recentItems =
              (json.decode(feedsResponse.body)['data']['recent_items'] as List)
                  .map((e) => Item.fromJSON(e))
                  .toList();
          saveRecentItems();
        }
      });
    } catch (e) {print (e);}
  }

  Future<void> getFeedsForUser(String id) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}feeds/$id';
    final client = new http.Client();
    final feedsResponse = await client.get(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('recentRestaurants') &&
          settingsRepo.useCaching.value) {
        print('recentRestaurants from prefs');
        recentRestaurants =
            (json.decode(prefs.getString('recentRestaurants')) as List)
                .map((e) => Restaurant.fromJSON(e))
                .toList();
      } else {
        recentRestaurants = (json.decode(feedsResponse.body)['data']
                ['recent_restaurants'] as List)
            .map((e) => Restaurant.fromJSON(e))
            .toList();
        saveRecentRestaurants();
      }
    });
    setState(() {
      if (prefs.containsKey('recentItems') && settingsRepo.useCaching.value) {
        print('recentItems from prefs');
        recentItems = (json.decode(prefs.getString('recentItems')) as List)
            .map((e) => Item.fromJSON(e))
            .toList();
      } else {
        recentItems =
            (json.decode(feedsResponse.body)['data']['recent_items'] as List)
                .map((e) => Item.fromJSON(e))
                .toList();
        saveRecentItems();
      }
    });
    if (prefs.containsKey('recommendedRestaurants') &&
        settingsRepo.useCaching.value) {
      print('recommendedRestaurants from prefs');
      setState(() {
        recommendedRestaurants =
            (json.decode(prefs.getString('recommendedRestaurants')) as List)
                .map((e) => Restaurant.fromJSON(e))
                .toList();
      });
    } else {
      List<Map> _temp = new List<Map>();
      (json.decode(feedsResponse.body)['data']['recommended_restaurants']
              as List)
          .forEach((e) => _temp.add(e));
      _temp.forEach((element) async {
        final response = await client.get(
            '${GlobalConfiguration().getValue('api_base_url')}restaurants/${element['id'].toString()}');
        if ((json.decode(response.body)['data']['restaurant_data'] as List)
                .length >
            0) {
          Restaurant _r = Restaurant.fromJSON(
              (json.decode(response.body)['data']['restaurant_data'] as List)
                  .elementAt(0));
          _r.distance = element['distance'];
          setState(() {
            recommendedRestaurants.add(_r);
            if (recommendedRestaurants.length == _temp.length)
              saveRecommendedRestaurants();
          });
        }
      });
    }
  }

  saveRecentRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (recentRestaurants.length > 0) {
      print('recentRestaurants saved');
      prefs.setString('recentRestaurants',
          json.encode(recentRestaurants.map((e) => e.toMap()).toList()));
    }
    prefs.setString('cachingDate', "${DateTime.now()}");
  }

  saveRecentItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (recentItems.length > 0) {
      print('recentItems saved');
      prefs.setString('recentItems',
          json.encode(recentItems.map((e) => e.toMap()).toList()));
    }
    prefs.setString('cachingDate', "${DateTime.now()}");
  }

  saveRecommendedRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (recommendedRestaurants.length > 0) {
      print('recommendedRestaurants saved');
      prefs.setString('recommendedRestaurants',
          json.encode(recommendedRestaurants.map((e) => e.toMap()).toList()));
    }
    prefs.setString('cachingDate', "${DateTime.now()}");
  }

  Future<void> refreshHome() async {
    setState(() {
      recentRestaurants = <Restaurant>[];
      recentItems = <Item>[];
      recommendedRestaurants = <Restaurant>[];
    });
    settingsRepo.setCachingOption().whenComplete(() async {
      await userRepo.currentUser.value.apiToken != null
          ? getFeedsForUser(userRepo.currentUser.value.id)
          : getFeeds();
    });
  }
}
