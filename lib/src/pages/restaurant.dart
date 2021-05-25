import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../elements/OrderFloatButtonWidget.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class RestaurantWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  RestaurantWidget({Key key, this.parentScaffoldKey, this.routeArgument})
      : super(key: key);

  @override
  _RestaurantWidgetState createState() {
    return _RestaurantWidgetState();
  }
}

class _RestaurantWidgetState extends StateMVC<RestaurantWidget> {
  RestaurantController _con;

  _RestaurantWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.restaurant = widget.routeArgument.param as Restaurant;
    if (!orderRepo.isSameRestaurant(_con.restaurant.id))
      orderRepo.clearOrderItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        body: RefreshIndicator(
          onRefresh: _con.refreshRestaurant,
          child: _con.restaurant == null
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.9),
                          expandedHeight: 300,
                          elevation: 0,
//                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                          automaticallyImplyLeading: false,
                          leading: new IconButton(
                            icon: new Icon(Icons.sort,
                                color: Theme.of(context).primaryColor),
                            onPressed: () => widget
                                .parentScaffoldKey.currentState
                                .openDrawer(),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Hero(
                              tag: (widget?.routeArgument?.heroTag ?? '') +
                                  _con.restaurant.id,
                              child: Image.network(
                                '${GlobalConfiguration().getValue('logos_base_url')}${_con.restaurant.logo_url}',
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Icon(Icons.error);
                                },
                              ),
                              /*CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${GlobalConfiguration().getValue('logos_base_url')}${_con.restaurant.logo_url}',
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),*/
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, left: 20, bottom: 10, top: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.restaurant?.name ?? '',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 32,
                                      child: Chip(
                                        padding: EdgeInsets.all(0),
                                        label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(_con.restaurant.rating,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor))),
                                            Icon(
                                              Icons.star_border,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: _con.restaurant.isClosed()
                                            ? Colors.red
                                            : Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: _con.restaurant.isClosed()
                                        ? Text(
                                            S.of(context).closed,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          )
                                        : Text(
                                            S.of(context).open,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 3),
                                      decoration: BoxDecoration(
                                          color:
                                              _con.restaurant.reservation_active
                                                  ? Colors.green
                                                  : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: Text(
                                        S.of(context).reservation,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      )),
                                  Expanded(child: SizedBox(height: 0)),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Text(
                                      _con.restaurant.distance != null
                                          ? _con.restaurant.distance.substring(
                                              0,
                                              _con.restaurant.distance
                                                  .lastIndexOf(' '))
                                          : '0.00 km',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                ],
                              ),
                              /*Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Helper.applyHtml(
                                    context, _con.restaurant.description),
                              ),*/
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  leading: Icon(
                                    Icons.stars,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).information,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Helper.applyHtml(
                                    context, _con.restaurant.getTimeInfo()),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.restaurant.address ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          /*Navigator.of(context).pushNamed(
                                              '/Pages',
                                              arguments: new RouteArgument(
                                                  id: '1',
                                                  param: _con.restaurant));*/
                                        },
                                        child: Icon(
                                          Icons.directions,
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '${_con.restaurant.contact_number}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          launch(
                                              "tel:${_con.restaurant.contact_number}");
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 32,
                      right: 20,
                      child: OrderFloatButtonWidget(
                          iconColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).hintColor),
                    ),
                  ],
                ),
        ));
  }
}
