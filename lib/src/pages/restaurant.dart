import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/table.dart';
import '../models/reservation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/user_repository.dart' as userRepo;
import '../elements/OrderFloatButtonWidget.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

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
  Reservation reservation = new Reservation();
  RestaurantTable selectedTable;
  TextEditingController commentController = new TextEditingController();
  int rating = 0;
  int h = DateTime.now().hour;
  int m = DateTime.now().minute;

  _RestaurantWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  getAvailableTables() {
    setState(() {
      reservation.restaurant_id = _con.restaurant.id;
      reservation.h = h.toString();
      reservation.m = m.toString();
      _con.getAvailableTables(reservation);
    });
  }

  @override
  void initState() {
    _con.restaurant = widget.routeArgument.param as Restaurant;
    if (!orderRepo.isSameRestaurant(_con.restaurant.id))
      orderRepo.clearOrderItems();
    getAvailableTables();
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
                                  /*Container(
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
                                  ),*/
                                  SizedBox(width: 20),
                                ],
                              ),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Row(
                                  children: [
                                    FlatButton(
                                      padding: EdgeInsets.all(5),
                                      onPressed: userRepo.currentUser.value
                                                      .apiToken !=
                                                  null &&
                                              userRepo.currentUser?.value
                                                      ?.role !=
                                                  "staff" &&
                                              userRepo.currentUser?.value
                                                      ?.role !=
                                                  "restaurant_manager"
                                          ? () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    // ignore: missing_return
                                                    return SimpleDialog(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20),
                                                      titlePadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                              vertical: 20),
                                                      title: Row(
                                                        children: <Widget>[
                                                          Icon(Icons
                                                              .rate_review_rounded),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "Review",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          )
                                                        ],
                                                      ),
                                                      children: <Widget>[
                                                        StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setStarState) {
                                                            return new Row(
                                                                children: new List
                                                                        .generate(
                                                                    5, (index) {
                                                              return IconButton(
                                                                  icon: index <
                                                                          rating
                                                                      ? Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: Theme.of(context)
                                                                              .accentColor)
                                                                      : Icon(
                                                                          Icons
                                                                              .star_border,
                                                                          color:
                                                                              Theme.of(context).hintColor),
                                                                  onPressed: () {
                                                                    setStarState(
                                                                        () {
                                                                      rating =
                                                                          index +
                                                                              1;
                                                                    });
                                                                  });
                                                            }));
                                                          },
                                                        ),
                                                        SizedBox(height: 20),
                                                        new TextFormField(
                                                          controller:
                                                              commentController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Comment",
                                                            labelStyle: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    12),
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.2))),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.5))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.2))),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Row(
                                                          children: <Widget>[
                                                            MaterialButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(S
                                                                  .of(context)
                                                                  .cancel),
                                                            ),
                                                            MaterialButton(
                                                              onPressed: () {
                                                                if (!commentController
                                                                        .text
                                                                        .isEmpty &&
                                                                    !commentController
                                                                        .text
                                                                        .trim()
                                                                        .isEmpty &&
                                                                    rating >
                                                                        0) {
                                                                  _con.addReview(
                                                                      commentController
                                                                          .text,
                                                                      rating);
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              },
                                                              child: Text(
                                                                S
                                                                    .of(context)
                                                                    .submit,
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor),
                                                              ),
                                                            ),
                                                          ],
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    );
                                                  });
                                            }
                                          : null,
                                      child: Text(
                                        S.of(context).add_review,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      color: Theme.of(context).accentColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      disabledColor:
                                          Theme.of(context).disabledColor,
                                    ),
                                    SizedBox(width: 20),
                                    FlatButton(
                                        padding: EdgeInsets.all(5),
                                        onPressed:
                                            userRepo.currentUser.value
                                                            .apiToken !=
                                                        null &&
                                                    userRepo.currentUser?.value
                                                            ?.role !=
                                                        "staff" &&
                                                    userRepo.currentUser?.value
                                                            ?.role !=
                                                        "restaurant_manager"
                                                ? () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          // ignore: missing_return
                                                          return SimpleDialog(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20),
                                                            titlePadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        20),
                                                            title: Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(Icons
                                                                    .today_rounded),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  "Reservation",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1,
                                                                )
                                                              ],
                                                            ),
                                                            children: <Widget>[
                                                              StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setReservingState) {
                                                                  return Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "pick time",
                                                                            style:
                                                                                Theme.of(context).textTheme.headline4,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 5),
                                                                          DropdownButton(
                                                                              hint: Text('hh'),
                                                                              value: h,
                                                                              items: Iterable<int>.generate(25).skip(1).toList().map((t) {
                                                                                return DropdownMenuItem(value: t, child: new Text('$t'));
                                                                              }).toList(),
                                                                              onChanged: (t) {
                                                                                setReservingState(() {
                                                                                  h = t;
                                                                                  getAvailableTables();
                                                                                });
                                                                              }),
                                                                          SizedBox(
                                                                              width: 2),
                                                                          DropdownButton(
                                                                              hint: Text('mm'),
                                                                              value: m,
                                                                              items: Iterable<int>.generate(60).toList().map((t) {
                                                                                return DropdownMenuItem(value: t, child: new Text('$t'));
                                                                              }).toList(),
                                                                              onChanged: (t) {
                                                                                setReservingState(() {
                                                                                  m = t;
                                                                                  getAvailableTables();
                                                                                });
                                                                              }),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "table",
                                                                            style:
                                                                                Theme.of(context).textTheme.headline4,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 5),
                                                                          ValueListenableBuilder(
                                                                            valueListenable:
                                                                                _con.availableTables,
                                                                            builder: (BuildContext context,
                                                                                value,
                                                                                Widget child) {
                                                                              return DropdownButton(
                                                                                  hint: Text('Choose table'),
                                                                                  value: selectedTable,
                                                                                  items: _con.availableTables.value.map((t) {
                                                                                    return DropdownMenuItem(value: t, child: new Text('table #${t.number} - ${t.no_of_chairs} chairs'));
                                                                                  }).toList(),
                                                                                  onChanged: (t) {
                                                                                    setReservingState(() {
                                                                                      selectedTable = t;
                                                                                    });
                                                                                  });
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(S
                                                                        .of(context)
                                                                        .cancel),
                                                                  ),
                                                                  MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (h != null &&
                                                                          m !=
                                                                              null &&
                                                                          selectedTable !=
                                                                              null) {
                                                                        reservation.h =
                                                                            h.toString();
                                                                        reservation.m =
                                                                            m.toString();
                                                                        reservation.table_id =
                                                                            selectedTable.id;
                                                                        _con.addReservation(reservation).then((value) => Navigator.of(context).pushNamed(
                                                                            '/Pages',
                                                                            arguments:
                                                                                0));
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      S
                                                                          .of(context)
                                                                          .submit,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).accentColor),
                                                                    ),
                                                                  ),
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                : null,
                                        child: Text(
                                          S.of(context).reserve_table,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        color: Theme.of(context).accentColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        disabledColor:
                                            Theme.of(context).disabledColor),
                                  ],
                                ),
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
                                          launch(
                                              "geo:${_con.restaurant.latitude},${_con.restaurant.longitude}");
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
                    userRepo.currentUser?.value?.role != "restaurant_manager"
                        ? Positioned(
                            top: 32,
                            right: 20,
                            child: OrderFloatButtonWidget(
                                iconColor: Theme.of(context).primaryColor,
                                labelColor: Theme.of(context).hintColor),
                          )
                        : SizedBox(height: 0),
                  ],
                ),
        ));
  }
}
