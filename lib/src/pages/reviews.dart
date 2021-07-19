import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/restaurant.dart';
import '../models/review.dart';
import '../controllers/restaurant_controller.dart';
import '../models/route_argument.dart';
import '../elements/ReviewsListWidget.dart';

class ReviewsWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ReviewsWidget({Key key, this.parentScaffoldKey, this.routeArgument}) : super(key: key);

  @override
  _ReviewsWidgetState createState() {
    return _ReviewsWidgetState();
  }
}

class _ReviewsWidgetState extends StateMVC<ReviewsWidget> {
  RestaurantController _con;
  final commentController = TextEditingController();

  _ReviewsWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.restaurant = widget.routeArgument.param as Restaurant;
    _con.getRestaurantReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: Icon(Icons.close),
          color: Theme.of(context).hintColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _con.restaurant?.name ?? '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 0)),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: _con.getRestaurantReviews,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Icon(
                    Icons.rate_review,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).reviews,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                ReviewsListWidget(
                  reviewsList: _con.reviews,
                ),
              ],
            ),
          )),
    );
  }
}
